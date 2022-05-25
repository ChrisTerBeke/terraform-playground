resource "google_compute_global_address" "static_ip" {
  count = var.enabled && var.create_static_ip ? 1 : 0

  name = "${var.name}-global"
}
