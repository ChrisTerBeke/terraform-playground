resource "google_compute_backend_service" "backend" {
  project         = var.project_id
  name            = "${var.name}-backend"
  protocol        = "HTTPS"
  timeout_sec     = 30
  enable_cdn      = false
  security_policy = google_compute_security_policy.waf.id

  # dynamic "backend" {
  #   for_each = var.cloud_run_services

  #   content {
  #     group = google_compute_region_network_endpoint_group.network_endpoint_group[backend.key].id
  #   }
  # }
}
