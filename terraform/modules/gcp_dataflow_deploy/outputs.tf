output "storage_url" {
  value = "gs://${coalescelist(google_storage_bucket_object.dataflow_metadata.*.bucket, [""])[0]}/${coalescelist(google_storage_bucket_object.dataflow_metadata.*.name, [""])[0]}"
}
