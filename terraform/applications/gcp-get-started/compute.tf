resource "google_compute_address" "gcp_get_started_debian_static_ip" {
  name = "gcp-get-started-debian-static-ip"
}

resource "google_compute_instance" "gcp_get_started_debian_vm" {
  name         = "gcp-get-started-debian"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.gcp_get_started_vpc_network.name

    access_config {
      nat_ip = google_compute_address.gcp_get_started_debian_static_ip.address
    }
  }

  depends_on = [
    google_compute_network.gcp_get_started_vpc_network,
    google_compute_address.gcp_get_started_debian_static_ip,
  ]
}
