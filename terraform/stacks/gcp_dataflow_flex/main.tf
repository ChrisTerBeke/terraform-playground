module "pubsub" {
  source = "../gcp_pubsub"

  enabled             = var.enabled
  project_id          = var.project_id
  name_prefix         = var.name_prefix
  create_subscription = true
}

module "bigquery" {
  source = "../gcp_bigquery"

  enabled          = var.enabled
  project_id       = var.project_id
  name_prefix      = var.name_prefix
  location         = var.bigquery_location
  schema_file_path = var.bigquery_schema_file_path
}

module "dataflow_simple" {
  source = "../../modules/gcp_dataflow_flex"

  project_id                = var.project_id
  region                    = var.region
  name_prefix               = var.name
  enabled                   = var.enabled
  vcp_subnet_name           = var.vcp_subnet_name
  template_storage_bucket   = module.deploy_template_simple.template_storage_bucket
  template_storage_path     = module.deploy_template_simple.template_storage_path
  max_workers               = 2

  job_parameters = {
    input_subscription = module.pubsub.subscription_id
    output_table       = module.bigquery.table_id
  }

  depends_on = [
    google_project_service.dataflow,
    module.deploy_template_simple,
    module.pubsub,
    module.bigquery,
  ]
}
