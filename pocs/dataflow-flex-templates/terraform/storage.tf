resource "google_storage_bucket" "storage_bucket" {
  name     = "christerbeke-dataflow-storage"
  location = "EU"
}

resource "google_storage_bucket_object" "dataflow_metadata" {
  name    = "templates/streaming-beam/metadata.json"
  bucket  = google_storage_bucket.storage_bucket.name
  content = "{}"

  // will be dynamically updated by Cloud Build job
  lifecycle {
    ignore_changes = [
      content,
      detect_md5hash,
    ]
  }
}
