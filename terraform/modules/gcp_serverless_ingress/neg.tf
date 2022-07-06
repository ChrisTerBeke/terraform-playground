resource "google_compute_region_network_endpoint_group" "network_endpoint_group" {
  for_each = var.cloud_run_services

  project               = var.project_id
  name                  = "${var.name}-${each.key}-neg"
  region                = each.key
  network_endpoint_type = "SERVERLESS"

  # TODO: make dynamic based on serverless type
  cloud_run {
    service = each.value
  }
}
