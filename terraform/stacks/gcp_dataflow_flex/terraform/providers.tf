terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.16.0"
    }
  }
}

resource "google_project_service" "dataflow" {
  service            = "dataflow.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
