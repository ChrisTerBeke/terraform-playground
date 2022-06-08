resource "google_compute_security_policy" "waf" {
  provider = google-beta

  project = var.project_id
  name    = "${var.name}-waf"

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = true
      rule_visibility = "STANDARD"
    }
  }
}
