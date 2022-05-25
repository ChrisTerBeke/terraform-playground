resource "google_compute_region_network_endpoint_group" "neg" {
  count = var.enabled ? 1 : 0

  name                  = "${var.name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  # TODO: make dynamic based on serverless type?
  cloud_run {
    service = var.cloud_run_service
  }
}
