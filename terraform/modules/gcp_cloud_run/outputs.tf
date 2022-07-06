output "regions_to_services" {
  value = { for r in var.regions : r => google_cloud_run_service.service[r].name }
}
