resource "google_compute_network" "network" {
  count = var.enabled ? 1 : 0

  name                    = var.name
  project                 = var.project_id
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "subnetwork" {
  count = var.enabled && var.create_subnet ? 1 : 0

  name                     = var.name
  project                  = var.project_id
  network                  = google_compute_network.network[0].id
  region                   = var.subnet_region
  ip_cidr_range            = var.subnet_cidr_range
  private_ip_google_access = true
}
