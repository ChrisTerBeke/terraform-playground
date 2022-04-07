module "project_playground_christerbeke" {
  source = "./modules/gcp_project"

  name            = "playground-christerbeke"
  project_id      = "playground-christerbeke"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account

  labels = {
    managed_by = "terraform"
  }
}

module "network_playground" {
  source = "./modules/gcp_network"

  project_id = module.project_playground_christerbeke.project_id
  name       = "playground-network"
}

module "dataflow_flex_template_stack" {
  source = "./stacks/gcp_dataflow_flex/terraform"

  project_id = module.project_playground_christerbeke.project_id
}
