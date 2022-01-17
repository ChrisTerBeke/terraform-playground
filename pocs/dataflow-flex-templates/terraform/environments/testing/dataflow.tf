module "deploy_template_simple" {
  source = "../../modules/deploy"

  name_prefix                = "simple"
  template_github_repository = "ChrisTerBeke/terraform-playground:main"
  template_directory         = "pocs/dataflow-flex-templates/templates/simple"
  storage_location           = local.default_location
}

module "dataflow_simple" {
  source = "../../modules/dataflow"

  name_prefix               = "ctb-simple"
  enabled                   = true
  bigquery_schema_file_path = file("../../../templates/simple/schema.json")
  bigquery_location         = local.default_location
  vpc_subnet_ip_block       = "10.2.0.0"
  template_storage_bucket   = module.deploy_template_simple.template_storage_bucket
  template_storage_path     = module.deploy_template_simple.template_storage_path
}

module "dataflow_simple_2" {
  source = "../../modules/dataflow"

  name_prefix               = "ctb-simple-two"
  enabled                   = true
  bigquery_schema_file_path = file("../../../templates/simple/schema.json")
  bigquery_location         = local.default_location
  vpc_subnet_ip_block       = "10.3.0.0"
  template_storage_bucket   = module.deploy_template_simple.template_storage_bucket
  template_storage_path     = module.deploy_template_simple.template_storage_path
}
