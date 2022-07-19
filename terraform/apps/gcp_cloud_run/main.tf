resource "random_string" "cloud_run_version_name" {
  count  = var.version_name == null ? 1 : 0
  length = 6
}

locals {
  version_name = var.version_name == null ? random_string.cloud_run_version_name.0.result : var.version_name
}

module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id         = var.project_id
  name               = var.app_name
  revision           = local.version_name
  regions            = var.regions
  image              = var.image
  ingress_annotation = "internal-and-cloud-load-balancing"

  # TODO: make this configurable
  revisions = {
    "${local.version_name}" = 100
  }
}

module "ingress" {
  source = "../../modules/gcp_serverless_ingress"

  project_id         = var.project_id
  name               = var.app_name
  domains            = var.domains
  cloud_run_services = module.cloud_run.regions_to_services

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
