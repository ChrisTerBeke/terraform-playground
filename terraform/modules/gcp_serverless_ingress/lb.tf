resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_url_map" "url_map_redirect" {
  project = var.project_id
  name    = "${var.name}-url-map-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" // 301
    strip_query            = false
    https_redirect         = true
  }
}
