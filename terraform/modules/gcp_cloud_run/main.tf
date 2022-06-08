resource "google_cloud_run_service" "service" {
  project  = var.project_id
  name     = var.name
  location = var.region

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

  # TODO: use separate service account for Cloud Run services

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
  project  = var.project_id
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [
    google_cloud_run_service.service,
  ]
}
