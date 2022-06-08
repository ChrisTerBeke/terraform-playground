resource "google_service_account" "account" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = try(var.display_name, var.account_id)
}

resource "google_project_iam_member" "account_iam_member" {
  for_each = toset(var.roles)

  project = var.project_id
  member  = "serviceAccount:${google_service_account.account.email}"
  role    = "roles/${each.key}"
}
