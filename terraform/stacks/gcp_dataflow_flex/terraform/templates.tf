module "deploy_template_simple" {
  source = "../../../modules/gcp_dataflow_deploy"

  project_id                 = var.project_id
  name_prefix                = "simple"
  template_github_repository = "ChrisTerBeke/terraform-playground:main"
  template_directory         = "terraform/stacks/gcp_dataflow_flex/templates/simple"
  storage_location           = local.default_location
}