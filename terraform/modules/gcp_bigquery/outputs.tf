output "table_id" {
  value = "${var.project_id}:${coalescelist(google_bigquery_dataset.dataset.*.dataset_id, [""])[0]}.${coalescelist(google_bigquery_table.table.*.table_id, [""])[0]}"
}
