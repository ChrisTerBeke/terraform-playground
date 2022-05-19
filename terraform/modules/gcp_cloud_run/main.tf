resource "google_cloud_run_service" "service" {
  count = var.enabled ? 1 : 0

  name     = var.name
  location = var.location
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

  dynamic "traffic" {
    for_each = var.revisions
    content {
      revision_name = traffic.key
      percent       = traffic.value
    }
  }
}
