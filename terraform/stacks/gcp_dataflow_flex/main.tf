resource "google_project_service" "dataflow" {
  count = var.enabled ? 1 : 0

  service            = "dataflow.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild" {
  count = var.enabled ? 1 : 0

  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
