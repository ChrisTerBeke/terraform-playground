resource "google_compute_address" "gcp_get_started_debian_static_ip" {
  name = "gcp-get-started-debian-static-ip"
}

resource "google_compute_firewall" "gcp_get_started_allow_ssh" {
  name          = "gcp-get-started-allow-ssh"
  network       = google_compute_network.gcp_get_started_vpc_network.name
  target_tags   = ["gcp-get-started-allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [
    google_compute_network.gcp_get_started_vpc_network,
  ]
}

resource "google_compute_instance" "gcp_get_started_debian_vm" {
  name         = "gcp-get-started-debian"
  machine_type = "f1-micro"
  tags         = ["gcp-get-started-allow-ssh"]

  metadata = {
    ssh-keys = "chris:${file("./ssh/google_compute_engine.pub")}"
  }

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
