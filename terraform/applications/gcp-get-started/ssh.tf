resource "tls_private_key" "gcp_get_started_ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
