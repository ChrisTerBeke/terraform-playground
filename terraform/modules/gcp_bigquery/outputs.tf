output "table_id" {
  value = "${var.project_id}:${google_bigquery_dataset.dataset.dataset_id}.${google_bigquery_table.table.table_id}"
}
