resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = local.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  project                  = var.project_id
  name                     = local.vpc_subnet_name
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = local.vpc_subnet_cidr_range
  private_ip_google_access = true
}
