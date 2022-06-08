resource "google_iap_web_backend_service_iam_binding" "iam_binding" {
  project             = var.project_id
  web_backend_service = var.backend_service
  role                = "roles/iap.httpsResourceAccessor"
  members             = var.iam_members
}
