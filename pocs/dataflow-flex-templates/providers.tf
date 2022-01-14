terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
  }
}

provider "google" {
  project = "playground-christerbeke"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

provider "google-beta" {
  project = "playground-christerbeke"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

resource "google_project_service" "dataflow" {
  service            = "dataflow.googleapis.com"
  disable_on_destroy = false
}
