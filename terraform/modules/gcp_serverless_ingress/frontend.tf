resource "google_compute_global_forwarding_rule" "frontend" {
  project    = var.project_id
  name       = "${var.name}-frontend"
  target     = google_compute_target_https_proxy.https_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.static_ip.0.address
}

resource "google_compute_global_forwarding_rule" "frontend_redirect" {
  project    = var.project_id
  name       = "${var.name}-frontend-redirect"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.static_ip.0.address
}
