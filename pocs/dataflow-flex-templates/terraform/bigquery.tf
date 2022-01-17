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
