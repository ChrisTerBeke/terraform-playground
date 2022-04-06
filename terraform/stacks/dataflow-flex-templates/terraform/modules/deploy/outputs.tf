output "template_storage_bucket" {
  value = google_storage_bucket_object.dataflow_metadata.bucket
}

output "template_storage_path" {
  value = google_storage_bucket_object.dataflow_metadata.name
}
