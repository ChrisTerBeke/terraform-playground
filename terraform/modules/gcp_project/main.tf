resource "google_project" "project" {
  name                = var.name
  project_id          = var.project_id
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  labels              = var.labels
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "project_service" {
  for_each = toset(var.services)

  project                    = var.project_id
  service                    = "${each.key}.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}
