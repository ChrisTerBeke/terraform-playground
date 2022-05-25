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

resource "google_compute_url_map" "url_map" {
  count = var.enabled ? 1 : 0

  project         = var.project_id
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.backend.0.id
}

resource "google_compute_url_map" "url_map_redirect" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = "${var.name}-url-map-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" // 301
    strip_query            = false
    https_redirect         = true
  }
}
