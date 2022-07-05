module "cloud_run" {
  source   = "../../modules/gcp_cloud_run"
  for_each = toset(var.regions) // TODO: move for_each into this module?

  project_id         = var.project_id
  name               = "${var.app_name}-${each.key}"
  revision_name      = "${var.app_name}-6"
  region             = each.key
  image              = var.image
  ingress_annotation = "internal-and-cloud-load-balancing"

  revisions = {
    "${var.app_name}-6" = 100
  }
}

module "ingress" {
  source = "../../modules/gcp_serverless_ingress"

  project_id         = var.project_id
  name               = var.app_name
  domains            = var.domains
  cloud_run_services = { for r in var.regions : r => module.cloud_run[r].service_name }

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
