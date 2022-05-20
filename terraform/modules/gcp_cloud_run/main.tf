resource "google_cloud_run_service" "service" {
  count = var.enabled ? 1 : 0

  name     = var.name
  location = var.region
  project  = var.project_id

  template {
    spec {
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
      "run.googleapis.com/ingress" = var.ingress_annotation
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

resource "google_cloud_run_service_iam_member" "service_iam_member" {
  count = var.enabled ? 1 : 0

  project  = var.project_id
  service  = google_cloud_run_service.service.0.name
  location = google_cloud_run_service.service.0.location
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_service.service,
  ]
}
