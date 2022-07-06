module "cloud_run" {
  source = "../../modules/gcp_cloud_run"

  project_id         = var.project_id
  name               = var.app_name
  version            = "latest"
  regions            = var.regions
  image              = var.image
  ingress_annotation = "internal-and-cloud-load-balancing"

  revisions = {
    "latest" = 100
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
