resource "google_compute_network" "vpc_network" {
  name                            = local.vpc_network_name
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = local.vpc_subnet_name
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = local.vpc_subnet_cidr_range
  private_ip_google_access = true
}
