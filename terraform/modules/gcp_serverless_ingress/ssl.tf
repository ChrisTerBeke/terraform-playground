resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = "${var.name}-ssl-cert"

  managed {
    domains = var.domains
  }
}

resource "google_compute_ssl_policy" "ssl_policy" {
  count = var.enabled ? 1 : 0

  project         = var.project_id
  name            = "${var.name}-ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}
