output "template_storage_bucket" {
  value = coalescelist(google_storage_bucket_object.dataflow_metadata.*.bucket, [""])[0]
}

output "template_storage_path" {
  value = coalescelist(google_storage_bucket_object.dataflow_metadata.*.name, [""])[0]
}
