# How to use OS Login for SSH access to VMs on GCP

A few weeks ago I blogged about how to use Terraform to automatically provision SSH keys for a VM on GCP.
On of the recommendendations I gave at the end was using OS Login, instead of managing keys for each individual machine.
In this blog post we will take a look at OS Login and how it can help you to keep your SSH keys clean.

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
