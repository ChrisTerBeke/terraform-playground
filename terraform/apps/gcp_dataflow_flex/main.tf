# pipeline: pubsub -> dataflow -> bigquery

# module "pubsub" {
#   source = "../gcp_pubsub"

#   enabled             = var.enabled
#   project_id          = var.project_id
#   name_prefix         = var.name_prefix
#   create_subscription = true
# }

# module "bigquery" {
#   source = "../gcp_bigquery"

#   enabled          = var.enabled
#   project_id       = var.project_id
#   name_prefix      = var.name_prefix
#   location         = var.bigquery_location
#   schema_file_path = var.bigquery_schema_file_path
# }

module "dataflow_template" {
  source = "../modules/gcp_dataflow_deploy"

  enabled                    = var.enabled
  project_id                 = var.project_id
  name_prefix                = var.app_name
  storage_location           = var.template_storage_location
  template_github_repository = var.template_github_repository
  template_directory         = var.template_directory
}

module "dataflow_job" {
  source = "../modules/gcp_dataflow_flex"

  enabled              = var.enabled
  project_id           = var.project_id
  name_prefix          = var.app_name
  region               = var.region
  vcp_subnet_name      = var.vcp_subnet_name
  template_storage_url = module.dataflow_template.storage_url
  extra_roles          = ["bigquery.dataOwner", "pubsub.subscriber", "pubsub.viewer"]

  job_parameters = {
    # TODO
  }

  depends_on = [
    module.dataflow_template,
  ]
}
