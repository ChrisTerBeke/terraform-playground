module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id         = var.project_id
  enabled            = var.enabled
  name               = var.app_name
  revision_name      = "${var.app_name}-2"
  region             = var.region
  image              = var.image
  # ingress_annotation = "internal-and-cloud-load-balancing"

  env_vars = {
    "hello" = "world"
  }

  revisions = {
    "${var.app_name}-1" = 50
    "${var.app_name}-2" = 50
  }
}
