# How to create a VM with SSH enabled on GCP

> The blog post is available at the [Binx.io website](https://binx.io/blog/2022/01/07/how-to-create-a-vm-with-ssh-enabled-on-gcp/).

Sometimes you need a quick Linux environment to try something out.
While a tool like Google Cloud Shell works perfectly fine for this purpose,
it's much more fun to dive into some Terraform code and learn something along the way!
In this post I will cover the needed Terraform config to SSH into a VM instance on GCP.

## Set up GCP

Our solution will use several GCP APIs that need to be enabled:

```hcl
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

> Be sure to run `gcloud auth application-default login` so we don't need set up GCP access manually.

## Generate an SSH key pair

Since we want to SSH into our VM that we'll create later, we need to generate an RSA keypair.
We can use the [`hashicorp/tls` provider](https://registry.terraform.io/providers/hashicorp/tls/latest) to automate this:

```hcl
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

resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = ".ssh/google_compute_engine"
  file_permission = "0600"

  depends_on = [
    tls_private_key.ssh,
  ]
}
```

We write the private key to local file so we can actually use it later.

> Note: the private key will be part of the state, so don't use this method if you use a shared remote state!

## Create a VPC network

When creating a new Google Cloud Project, a default VPC network is created.
This network works fine, but since it's recommended to create separate networks for isolation, let's do that:

```hcl
resource "google_compute_network" "vpc_network" {
  name = "my-network"
}
```

## Create a compute instance

Now let's create our VM and associated resources.

```hcl
resource "google_compute_address" "static_ip" {
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

data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "debian_vm" {
  name         = "debian"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"] // this receives the firewall rule

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
```

## Connect to the VM using SSH

Now that all of our resources are created, how do we use SSH to connect to the VM?
Let's define an output to get the information we need to do that:

```hcl
output "public_ip" {
  value = google_compute_address.static_ip.address

  depends_on = [
    google_compute_address.static_ip,
  ]
}
```

Print the value for the static IP:

```bash
terraform output public_ip
```

And now we can use SSH to connect to the VM:

```bash
ssh -i .ssh/google_compute_engine <gcp-username>@<static-ip>
```

Enjoy your Debian environment!

## Bonus: use a remote runner

When you use a remote runner like [Terraform Cloud](https://www.terraform.io/cloud), you cannot output the private key to a local file.
We can still obtain the private key by using an extra output even if it's sensitive:

```hcl
output "ssh_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true

  depends_on = [
    tls_private_key.ssh,
  ]
}
```

Now use the following command to dump the private key into a local file:

```bash
terraform output -json | jq -r ".ssh_private_key.value" > .ssh/google_compute_engine
```

## Next steps

This blog uses SSH because almost everyone is familiar with it.
But there are other, more secure ways, to connect to a VM on GCP.
For example, [tunneling using IAP](https://cloud.google.com/iap/docs/using-tcp-forwarding#starting_ssh).
You can also read [our post about setting this up in Ansible](https://binx.io/blog/2021/03/10/how-to-tell-ansible-to-use-gcp-iap-tunneling/).
Furthermore, to reduce lingering public keys, Google recommends enabling [OS Login](https://cloud.google.com/compute/docs/instances/managing-instance-access).

