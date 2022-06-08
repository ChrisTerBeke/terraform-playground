output "storage_url" {
  value = "gs://${google_storage_bucket_object.dataflow_metadata.bucket}/${google_storage_bucket_object.dataflow_metadata.name}"
}
