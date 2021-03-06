resource "google_dns_managed_zone" "zone" {
  project    = var.project_id
  name       = var.zone_name
  dns_name   = "${var.domain}."
  visibility = "public"
}

resource "google_dns_record_set" "a_records" {
  for_each = var.a_records

  project      = var.project_id
  managed_zone = google_dns_managed_zone.zone.name
  name         = "${each.key}.${google_dns_managed_zone.zone.dns_name}"
  type         = "A"
  ttl          = 60
  rrdatas      = each.value
}
