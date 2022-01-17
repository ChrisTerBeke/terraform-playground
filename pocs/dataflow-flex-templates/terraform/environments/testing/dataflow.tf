module "dataflow_simple" {
  source = "../../modules/dataflow"

  name_prefix                 = "ctb-simple"
  template_github_repository  = "ChrisTerBeke/terraform-playground:main"
  template_source_directory   = "pocs/dataflow-flex-templates/templates/simple/dataflow"
  template_metadata_file_path = "pocs/dataflow-flex-templates/templates/simple/metadata.json"
  bigquery_schema_file_path   = file("../../../templates/simple/schema.json")
  vpc_subnet_ip_block         = "10.2.0.0"
}

module "dataflow_simple_2" {
  source = "../../modules/dataflow"

  name_prefix                 = "ctb-simple-two"
  enabled                     = false // set to true once template has been built and pushed
  template_github_repository  = "ChrisTerBeke/terraform-playground:main"
  template_source_directory   = "pocs/dataflow-flex-templates/templates/simple/dataflow"
  template_metadata_file_path = "pocs/dataflow-flex-templates/templates/simple/metadata.json"
  bigquery_schema_file_path   = file("../../../templates/simple/schema.json")
  vpc_subnet_ip_block         = "10.3.0.0"
}
