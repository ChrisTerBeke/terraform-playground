resource "google_storage_bucket" "storage_bucket" {
  count = var.enabled ? 1 : 0

  project  = var.project_id
  name     = local.storage_bucket_name
  location = var.storage_location
}

resource "google_storage_bucket_object" "dataflow_metadata" {
  count = var.enabled ? 1 : 0

  name    = local.storage_template_metadata_file_path
  bucket  = google_storage_bucket.storage_bucket[0].name
  content = "{}"

  // These attributes will be dynamically updated by Cloud Build job so we should ignore them here to prevent conflicts.
  lifecycle {
    ignore_changes = [
      content,
      detect_md5hash,
    ]
  }
}
