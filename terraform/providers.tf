terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.22.0"
    }
  }
}

provider "google" {
  region = var.gcp_default_region
}

provider "google-beta" {
  region = var.gcp_default_region
}
