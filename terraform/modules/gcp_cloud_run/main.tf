module "run_service_account" {
  source = "../gcp_service_account"

  project_id = var.project_id
  account_id = "${var.name}-sa"
  roles      = concat(["iam.serviceAccountUser"], var.service_account_roles)
}

resource "google_cloud_run_service" "service" {
  project  = var.project_id
  name     = var.name
  location = var.region

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
      name = var.revision_name
    }
  }

  metadata {
    annotations = {
      "autoscaling.knative.dev/minScale"         = var.min_scale
      "autoscaling.knative.dev/maxScale"         = var.max_scale
      "run.googleapis.com/ingress"               = var.ingress_annotation
      "run.googleapis.com/execution-environment" = "gen2"
      # "run.googleapis.com/vpc-access-connector" = ""
      # "run.googleapis.com/vpc-access-egress"    = "all-traffic"
    }
  }

  dynamic "traffic" {
    for_each = var.revisions

    content {
      revision_name = traffic.key
      percent       = traffic.value
    }
  }
}

# TODO: make configurable
resource "google_cloud_run_service_iam_member" "service_iam_member" {
  project  = var.project_id
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_service.service,
  ]
}
