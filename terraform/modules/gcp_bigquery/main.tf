resource "google_bigquery_dataset" "dataset" {
  count = var.enabled ? 1 : 0

  project    = var.project_id
  dataset_id = "${replace(var.name_prefix, "-", "_")}_dataset"
  location   = var.location
}

resource "google_bigquery_table" "table" {
  count = var.enabled ? 1 : 0

  project    = var.project_id
  table_id   = "${replace(var.name_prefix, "-", "_")}_table"
  dataset_id = google_bigquery_dataset.dataset[0].dataset_id

  time_partitioning {
    type = var.time_partitioning
  }
}
