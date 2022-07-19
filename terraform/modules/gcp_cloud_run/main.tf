module "run_service_account" {
  source = "../gcp_service_account"

  project_id = var.project_id
  account_id = "${var.name}-sa"
  roles      = concat(["iam.serviceAccountUser"], var.service_account_roles)
}

resource "google_cloud_run_service" "service" {
  for_each = toset(var.regions)

  project  = var.project_id
  name     = "${var.name}-${each.key}"
  location = each.key

  template {

    spec {
      service_account_name = module.run_service_account.email

      containers {
        image = var.image

        dynamic "env" {
          for_each = var.env_vars

          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = var.min_scale
        "autoscaling.knative.dev/maxScale"         = var.max_scale
        "run.googleapis.com/execution-environment" = "gen2"
        # "run.googleapis.com/vpc-access-connector" = ""
        # "run.googleapis.com/vpc-access-egress"    = "all-traffic"
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress"      = var.ingress_annotation
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }

  # TODO: support multiple revisions and traffic splitting
  # dynamic "traffic" {
  #   for_each = var.revisions

  #   content {
  #     revision_name = "${var.name}-${each.key}-${traffic.key}"
  #     percent       = traffic.value
  #   }
  # }
}

# TODO: make configurable
resource "google_cloud_run_service_iam_member" "service_iam_member" {
  for_each = toset(var.regions)

  project  = var.project_id
  service  = google_cloud_run_service.service[each.key].name
  location = google_cloud_run_service.service[each.key].location
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_service.service,
  ]
}
