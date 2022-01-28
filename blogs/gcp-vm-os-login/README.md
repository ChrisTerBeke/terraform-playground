# How to use OS Login for SSH access to VMs on GCP

A few weeks ago I blogged about how to [use Terraform to automatically provision SSH keys for a VM on GCP](https://binx.io/blog/2022/01/07/how-to-create-a-vm-with-ssh-enabled-on-gcp/).
On of the recommendendations I gave at the end was using OS Login, instead of managing keys for each individual machine.
In this blog post we will take a look at [OS Login](https://cloud.google.com/compute/docs/instances/managing-instance-access) and how it can help you to keep your SSH keys clean.

## What is OS Login

OS Login simplifies SSH key management by using IAM roles to grant or revoke SSH keys.
This removes the need for manually provisioning, managing and eventually removing these keys.
Since dangling keys pose a security risk, not having them at all is a great feature!

## Generate an RSA key pair

First you need an RSA key pair that you can add to our IAM user later on.

```bash
ssh-keygen -t rsa
ssh-add `~/.ssh/id_rsa`
```

> The default location (`~/.ssh/id_rsa`) is fine, but you can use any other location of course.

## Configuring OS Login in Terraform

Let's write some Terraform code to tell Google Cloud to add the public key to our IAM user.
This can be done by retrieving the email address for the currently authenticated user:

```hcl
data "google_client_openid_userinfo" "me" {}

resource "google_os_login_ssh_public_key" "cache" {
  user = data.google_client_openid_userinfo.me.email
  key  = file("~/.ssh/id_rsa.pub")
}
```

We also need to make sure that the IAM user is allowed to use OS Login:

```hcl
resource "google_project_iam_member" "project" {
  project = "<gcp_project_id>"
  role    = "roles/compute.osAdminLogin"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}
```

> If you are project owner or editor, this role is configured automatically.

## Create a VM with OS Login enabled

Now we can create a new compute engine instance.
We also create a static IP address that we can get the value of using a Terraform output when it is time to connect.

```hcl
resource "google_compute_address" "static_ip" {
  name = "debian-vm"
}

output "static_ip" {
  value = google_compute_address.static_ip.address
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  network       = "default"
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "debian_vm" {
  name         = "debian"
  machine_type = "f1-micro"
  tags         = ["allow-ssh"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
}
```

## Let's connect

```bash
ssh -i ~/.ssh/id_rsa <username>@$(terraform output --raw static_ip)
```

> Note: the username that the VM will recognize is your IAM email address transformed into snake case, for example `christerbeke@binx.io` -> `christerbeke_binx_io`.

And there you have it! SSH access to your virtual machine, without having to manage and rotate SSH keys per machine.

## Conclusion

When using SSH to connect to your virtual machines on Google Cloud, use the OS Login feature instead of separate SSH keys.
OS Login manages a single key that is associated with your IAM user and thus enhances security.
