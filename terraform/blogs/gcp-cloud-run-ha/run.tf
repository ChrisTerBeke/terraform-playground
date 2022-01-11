resource "google_cloud_run_service" "service" {
  for_each = toset(local.locations)

  name     = "service-${each.key}"
  location = each.key

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }

  depends_on = [
    google_project_service.run,
  ]
}
