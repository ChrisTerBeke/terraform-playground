resource "google_project_service" "gcp_get_started_project_service" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}
