resource "google_compute_network" "vpc_network" {
  name = "dataflow-network"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "dataflow-subnetwork-eu"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.2.0.0/16"
}

resource "google_pubsub_topic" "pubsub_topic" {
  name = "pubsub-topic"
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name  = "pubsub-subscription"
  topic = google_pubsub_topic.pubsub_topic.name
}

resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id = "bigquery_dataset"
  location   = "EU"
}

resource "google_bigquery_table" "bigquery_table" {
  table_id   = "bigquery-table"
  dataset_id = google_bigquery_dataset.bigquery_dataset.dataset_id
  schema     = file("schema.json")

  time_partitioning {
    type = "DAY"
  }
}

resource "google_storage_bucket" "storage_bucket" {
  name     = "christerbeke-dataflow-storage"
  location = "EU"
}

resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  name           = "dataflow-build"

  github {
    owner = "ChrisTerBeke"
    name  = "terraform-playground"

    push {
      branch = "^main$"
    }
  }

  build {
    step {
      id   = "Build docker image"
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "eu.gcr.io/playground-christerbeke/dataflow/streaming-beam:latest", "."]
    }

    step {
      id   = "Push docker image"
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "eu.gcr.io/playground-christerbeke/dataflow/streaming-beam:latest"]
    }

    step {
      id   = "Store template"
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "dataflow", "flex-template", "build",
        "gs://${google_storage_bucket.storage_bucket.name}/templates/streaming-beam/metadata.json",
        "--image", "eu.gcr.io/playground-christerbeke/dataflow/streaming-beam:latest",
        "--sdk-language", "PYTHON",
        "--metadata-file", "metadata.json",
      ]
    }
  }
}

// TODO: auto-detect deployment needed for job when metadata.json changed (use MD5 hash as label?)
resource "google_dataflow_flex_template_job" "dataflow_job" {
  provider                = google-beta
  name                    = "dataflow-flex-job"
  container_spec_gcs_path = "gs://${google_storage_bucket.storage_bucket.name}/templates/streaming-beam/metadata.json"

  parameters = {
    input_subscription = google_pubsub_subscription.pubsub_subscription.id
    output_table       = "playground-christerbeke:${google_bigquery_dataset.bigquery_dataset.dataset_id}.${google_bigquery_table.bigquery_table.table_id}"
    subnetwork         = "regions/${google_compute_subnetwork.vpc_subnetwork.region}/subnetworks/${google_compute_subnetwork.vpc_subnetwork.name}"
  }
}
