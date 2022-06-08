module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id    = var.project_id
  name          = var.app_name
  revision_name = "${var.app_name}-5"
  region        = var.region
  image         = var.image

  ingress_annotation = "internal-and-cloud-load-balancing"

  env_vars = {
    "hello" = "world"
  }

  revisions = {
    LATEST = 100
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
