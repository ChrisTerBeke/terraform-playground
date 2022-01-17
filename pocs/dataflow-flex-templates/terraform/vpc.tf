resource "google_compute_network" "vpc_network" {
  name = "dataflow-network"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "dataflow-subnetwork-eu"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.2.0.0/16"
}
