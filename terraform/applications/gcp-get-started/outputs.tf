output "gcp_get_started_debian_vm_public_ip" {
  description = "The public IP address to connect to the Debian VM."
  value       = google_compute_address.gcp_get_started_debian_static_ip.address

  depends_on = [
    google_compute_address.gcp_get_started_debian_static_ip,
  ]
}

output "gcp_get_started_debian_vm_ssh_private_key" {
  description = "The SSH private key to connect to the Debian VM."
  value       = tls_private_key.gcp_get_started_ssh_private_key.private_key_pem
  sensitive   = true

  depends_on = [
    tls_private_key.gcp_get_started_ssh_private_key,
  ]
}
