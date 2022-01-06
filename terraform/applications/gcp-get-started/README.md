# GCP + Terraform: Getting started

Sometimes you just need a small Debian machine to perform some Linux tasks.
While using a tool like Google Cloud Shell satisfies that requirement perfectly fine,
it's much more fun to write some Terraform code and learn something along the way!
In this blog post I will cover the needed Terraform solution to spin up a Debian VM and obtain SSH access to it.

## Google Cloud Platform

Our solution will use several GCP APIs that need to be enabled:

```terraform
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
  }
}

provider "google" {
  project = "<project_id>"
}

resource "google_project_service" "cloud_resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false

  depends_on = [
    google_project_service.cloud_resource_manager,
  ]
}
```

## SSH

Since we want to SSH into our VM that we'll create later, we need to generate an RSA keypair.
The [`hashicorp/tls` provider](https://registry.terraform.io/providers/hashicorp/tls/latest) can be used to automate this:

```terraform
terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "tls" {
  // no config needed
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

## VPC Network

When creating a new Google Cloud Project, a default VPC network is created.
This network works fine, but since it's typically recommended to create separate networks for isolation, let's do that.

```terraform
resource "google_compute_network" "vpc_network" {
  name = "my-network"
}
```

## Compute

Now let's create our VM and associated resources.
Technically we don't need a static IP address, but it makes connecting to the VM more predictable in case you want to leave it running for a longer time.

```terraform
resource "google_compute_address" "debian_vm_ip" {
  name = "debian-vm"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.vpc_network.name
  target_tags   = ["allow-ssh"] // this targets our tagged VM
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [
    google_compute_network.vpc_network,
  ]
}

resource "google_compute_instance" "debian_vm" {
  name         = "debian"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"] // this receives the firewall rule

  metadata = {
    ssh-keys = format("<gcp-username>:%s", tls_private_key.ssh.public_key_openssh)
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      nat_ip = google_compute_address.debian_vm_ip.address
    }
  }

  depends_on = [
    google_compute_network.vpc_network,
    google_compute_address.debian_vm_ip,
    tls_private_key.ssh,
  ]
}
```

## Connecting

Now that all of our resources are created, how do we use SSH to connect to the VM?
Let's define some outputs to get the information we need to do just that.

```terraform
output "public_ip" {
  description = "The public IP address to connect to the Debian VM."
  value       = google_compute_address.debian_vm_ip.address

  depends_on = [
    google_compute_address.debian_vm_ip,
  ]
}

output "ssh_private_key" {
  description = "The SSH private key to connect to the Debian VM."
  value       = tls_private_key.ssh.private_key_pem

  sensitive = true

  depends_on = [
    tls_private_key.ssh,
  ]
}
```

While our private key is sensitive information, we can still obtain it using `terraform output -json` in order to connect to the machine over SSH:

```bash
terraform output -json | jq -r ".ssh_private_key.value" > ~/.ssh/google_compute_engine
```

And now we can use SSH to connect to the VM:

```bash
ssh -i ~/.ssh/google_compute_engine <gcp-username@<vm-static-ip>
<gcp-username@debian:~$
```

Enjoy your Debian environment!
