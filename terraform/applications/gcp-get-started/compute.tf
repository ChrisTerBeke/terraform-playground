resource "google_compute_address" "static_ip" {
  name = "debian-vm"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.vpc_network.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [
    google_compute_network.vpc_network,
  ]
}

data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "debian_vm" {
  name         = "debian"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"]

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  depends_on = [
    google_compute_network.vpc_network,
    google_compute_address.static_ip,
    tls_private_key.ssh,
    google_project_service.compute,
  ]
}
