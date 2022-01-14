// TODO: add a google cloud build job that builds and stores the Docker image in Container Registry and the Dataflow flex template in Cloud Storage

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
