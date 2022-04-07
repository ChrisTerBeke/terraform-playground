module "dataflow_simple" {
  source = "../../modules/gcp_dataflow_flex"

  project_id                = var.project_id
  name_prefix               = var.name
  enabled                   = var.enabled
  bigquery_schema_file_path = file("${path.module}/templates/simple/schema.json")
  bigquery_location         = local.default_location
  vpc_subnet_ip_block       = "10.2.0.0"
  template_storage_bucket   = module.deploy_template_simple.template_storage_bucket
  template_storage_path     = module.deploy_template_simple.template_storage_path
  dataflow_max_workers      = 2

  depends_on = [
    module.deploy_template_simple,
    google_project_service.dataflow,
  ]
}
