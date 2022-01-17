resource "google_compute_network" "vpc_network" {
  name = local.vpc_network_name
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = local.vpc_subnet_name
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = local.vpc_subnet_cidr_range
}
