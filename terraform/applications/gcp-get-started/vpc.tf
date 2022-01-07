resource "google_compute_network" "vpc_network" {
  name = "gcp-get-started-network"

  depends_on = [
    google_project_service.compute,
  ]
}
