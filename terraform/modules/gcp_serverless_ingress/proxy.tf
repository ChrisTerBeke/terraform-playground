resource "google_compute_target_https_proxy" "https_proxy" {
  count = var.enabled ? 1 : 0

  project          = var.project_id
  name             = "${var.name}-target-proxy"
  url_map          = google_compute_url_map.url_map.0.id
  ssl_policy       = google_compute_ssl_policy.ssl_policy.0.id
  ssl_certificates = [] // google_compute_managed_ssl_certificate.ssl_cert.0.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = "${var.name}-redirect-proxy"
  url_map = google_compute_url_map.url_map_redirect.0.id
}
