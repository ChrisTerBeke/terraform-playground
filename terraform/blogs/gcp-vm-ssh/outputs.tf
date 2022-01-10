output "public_ip" {
  value = google_compute_address.static_ip.address

  depends_on = [
    google_compute_address.static_ip,
  ]
}

# This output can be used if we use a remote state that does not allow local file creation for the private key.
# output "ssh_private_key" {
#   value     = tls_private_key.ssh.private_key_pem
#   sensitive = true

#   depends_on = [
#     tls_private_key.ssh,
#   ]
# }
