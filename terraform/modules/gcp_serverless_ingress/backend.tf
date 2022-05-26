resource "google_compute_backend_service" "backend" {
  count = var.enabled ? 1 : 0

  project         = var.project_id
  name            = "${var.name}-backend"
  protocol        = "HTTPS"
  timeout_sec     = 30
  enable_cdn      = false
  security_policy = google_compute_security_policy.waf.0.id

  backend {
    group = google_compute_region_network_endpoint_group.neg.0.id
  }
}
