module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id    = var.project_id
  enabled       = var.enabled
  name          = var.app_name
  revision_name = "${var.app_name}-1"
  location      = var.location
  image         = var.image
  env_vars      = {}
  revisions     = {}
}
