resource "google_compute_network" "vpc_network" {
  count = var.enabled ? 1 : 0

  project                 = var.project_id
  name                    = local.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  count = var.enabled ? 1 : 0

  project                  = var.project_id
  name                     = local.vpc_subnet_name
  network                  = google_compute_network.vpc_network[0].id
  ip_cidr_range            = local.vpc_subnet_cidr_range
  private_ip_google_access = true
}
