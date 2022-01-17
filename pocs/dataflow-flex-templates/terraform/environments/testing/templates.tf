module "deploy_template_simple" {
  source = "../../modules/deploy"

  name_prefix                = "simple"
  template_github_repository = "ChrisTerBeke/terraform-playground:main"
  template_directory         = "pocs/dataflow-flex-templates/templates/simple"
  storage_location           = local.default_location
}
