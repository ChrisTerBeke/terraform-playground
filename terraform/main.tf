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

moved {
  from = module.project-playground-christerbeke
  to   = module.project_playground_christerbeke
}

module "network_playground" {
  source = "./modules/gcp_network"

  project_id = module.project_playground_christerbeke.project_id
  name       = "playground-network"
}
