resource "google_compute_managed_ssl_certificate" "cert" {
  project = var.project_id
  name    = "${var.name}-cert"

  managed {
    domains = var.domains
  }
}

resource "google_compute_ssl_policy" "ssl_policy" {
  project         = var.project_id
  name            = "${var.name}-ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}
