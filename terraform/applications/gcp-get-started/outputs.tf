output "gcp_get_started_debian_vm_public_ip" {
  value = google_compute_address.gcp_get_started_debian_static_ip.address

  depends_on = [
    google_compute_address.gcp_get_started_debian_static_ip,
  ]
}
