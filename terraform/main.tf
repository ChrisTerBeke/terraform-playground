module "project-playground-christerbeke" {
  source = "./modules/gcp_project"

  name            = "playground-christerbeke"
  project_id      = "playground-christerbeke"
  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account

  labels = {
    managed_by = "terraform"
  }
}
