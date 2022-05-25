resource "google_compute_security_policy" "waf" {
  provider = google-beta
  count    = var.enabled ? 1 : 0

  name = "${var.name}-waf"

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = true
      rule_visibility = "STANDARD"
    }
  }
}
