resource "google_dns_managed_zone" "zone" {
  project  = var.project_id
  name     = var.zone_name
  dns_name = "${var.domain}."
}

resource "google_dns_record_set" "record_set" {
  for_each = var.a_records

  project = var.project_id
  name    = each.key
  type    = "A"
  ttl     = 60
  rrdatas = each.value
}
