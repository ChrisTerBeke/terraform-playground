module "project_playground_christerbeke" {
  source = "./modules/gcp_project"

  name            = "playground-christerbeke"
  project_id      = "playground-christerbeke"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account
  services        = ["dataflow", "cloudbuild"]

  labels = {
    managed_by = "terraform"
  }
}

module "network_playground" {
  source = "./modules/gcp_network"

  project_id    = module.project_playground_christerbeke.project_id
  name          = "playground-network"
  create_subnet = true
  subnet_region = "europe-west1"

  depends_on = [
    module.project_playground_christerbeke,
  ]
}

module "dataflow_flex_simple" {
  source = "./stacks/gcp_dataflow_flex"

  project_id      = module.project_playground_christerbeke.project_id
  region          = "europe-west1"
  name            = "dataflow-flex-simple"
  enabled         = false
  vcp_subnet_name = module.network_playground.subnet_name

  depends_on = [
    module.project_playground_christerbeke,
    module.network_playground,
  ]
}
