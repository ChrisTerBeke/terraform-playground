resource "google_compute_global_forwarding_rule" "frontend" {
  count = var.enabled ? 1 : 0

  name       = "${var.name}-frontend"
  target     = google_compute_target_https_proxy.https_proxy.0.id
  port_range = "443"
  ip_address = google_compute_global_address.static_ip.0.address
}

resource "google_compute_global_forwarding_rule" "frontend_redirect" {
  count = var.enabled ? 1 : 0

  name       = "${var.name}-frontend-redirect"
  target     = google_compute_target_http_proxy.http_proxy.0.id
  port_range = "80"
  ip_address = google_compute_global_address.static_ip.0.address
}
