resource "google_compute_global_address" "static_ip" {
  project = var.project_id
  name    = "${var.name}-global"
}
