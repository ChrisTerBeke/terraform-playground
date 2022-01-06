resource "google_project_service" "gcp_get_started_project_service_cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "gcp_get_started_project_service_compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false

  depends_on = [
    google_project_service.gcp_get_started_project_service_cloud_resource_manager,
  ]
}
