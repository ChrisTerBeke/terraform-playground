import argparse
import json
import logging
import time
from typing import Any, Dict, List

import apache_beam as beam
import apache_beam.transforms.window as window
from apache_beam.options.pipeline_options import PipelineOptions


# Defines the BigQuery schema for the output table.
SCHEMA = ",".join(
    [
        "url:STRING",
        "num_reviews:INTEGER",
        "score:FLOAT64",
        "first_date:TIMESTAMP",
        "last_date:TIMESTAMP",
    ]
)


def parse_json_message(message: str) -> Dict[str, Any]:
    """
    Parse incoming JSON message and return structured data.
    """
    row = json.loads(message)
    return {
        "processing_time": int(time.time()),
        "url": row["url"],
        "score": 1.0 if row["review"] == "positive" else 0.0,
    }


def run(input_subscription: str, output_table: str, beam_args: List[str] = None):
    """
    Run the Beam pipeline.
    """
    options = PipelineOptions(
        beam_args, save_main_session=True, streaming=True)

    with beam.Pipeline(options=options) as pipeline:
        messages = (
            pipeline
            | "Read from PubSub" >> beam.io.ReadFromPubSub(subscription=input_subscription).with_output_types(bytes)
            | "UTF-8 bytes to string" >> beam.Map(lambda msg: msg.decode("utf-8"))
            | "Parse JSON messages" >> beam.Map(parse_json_message)
            | "Fixed-size windows" >> beam.WindowInto(window.FixedWindows(60, 0))
            | "Add URL keys" >> beam.WithKeys(lambda msg: msg["url"])
            | "Group by URLs" >> beam.GroupByKey()
            | "Get statistics" >> beam.MapTuple(lambda url, messages: {
                "url": url,
                "num_reviews": len(messages),
                "score": sum(msg["score"] for msg in messages) / len(messages),
                "first_date": min(msg["processing_time"] for msg in messages),
                "last_date": max(msg["processing_time"] for msg in messages),
            })
        )

        _ = messages | "Write to BigQuery" >> beam.io.WriteToBigQuery(output_table, schema=SCHEMA)


if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input_subscription",
        help="Input PubSub subscription specified as projects/<PROJECT>/subscriptions/<SUBSCRIPTION>",
    )
    parser.add_argument(
        "--output_table",
        help="Output BigQuery table for results specified as PROJECT:DATASET.TABLE or DATASET.TABLE",
    )
    args, beam_args = parser.parse_known_args()

    run(
        input_subscription=args.input_subscription,
        output_table=args.output_table,
        beam_args=beam_args,
    )
