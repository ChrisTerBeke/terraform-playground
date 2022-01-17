resource "google_bigquery_dataset" "bigquery_dataset" {
  dataset_id = local.bigquery_dataset_id
  location   = var.default_location
}

resource "google_bigquery_table" "bigquery_table" {
  table_id   = local.bigquery_table_id
  dataset_id = google_bigquery_dataset.bigquery_dataset.dataset_id
  schema     = var.bigquery_schema_file_path

  time_partitioning {
    type = "DAY"
  }
}
