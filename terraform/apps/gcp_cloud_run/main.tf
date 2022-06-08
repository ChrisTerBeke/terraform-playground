module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id    = var.project_id
  name          = var.app_name
  revision_name = "${var.app_name}-2"
  region        = var.region
  image         = var.image

  ingress_annotation = "internal-and-cloud-load-balancing"

  env_vars = {
    "hello" = "world"
  }

  revisions = {
    "${var.app_name}-1" = 50
    "${var.app_name}-2" = 50
  }

  # TODO: HA with multiple regions
}

module "ingress" {
  source = "../../modules/gcp_serverless_ingress"

  project_id        = var.project_id
  name              = var.app_name
  region            = var.region
  cloud_run_service = module.cloud_run.service_name
  domains           = var.domains

  depends_on = [
    module.cloud_run,
  ]
}

# module "iap" {
#   source = "../../modules/gcp_iap"

#   project_id      = var.project_id
#   backend_service = ""
#   iam_members     = []
# }
