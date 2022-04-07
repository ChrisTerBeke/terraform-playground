resource "google_bigquery_dataset" "bigquery_dataset" {
  count = var.enabled ? 1 : 0

  project    = var.project_id
  dataset_id = local.bigquery_dataset_id
  location   = var.bigquery_location
}

resource "google_bigquery_table" "bigquery_table" {
  count = var.enabled ? 1 : 0
  
  project    = var.project_id
  table_id   = local.bigquery_table_id
  dataset_id = google_bigquery_dataset.bigquery_dataset[0].dataset_id
  schema     = var.bigquery_schema_file_path

  time_partitioning {
    type = "DAY"
  }
}
