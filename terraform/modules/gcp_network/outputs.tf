output "network_id" {
  value = google_compute_network.network.id
}

output "subnet_name" {
  value = "regions/${coalescelist(google_compute_subnetwork.subnetwork.*.region, [""])[0]}/subnetworks/${coalescelist(google_compute_subnetwork.subnetwork.*.name, [""])[0]}"
}
