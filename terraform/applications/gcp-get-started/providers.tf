terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
  }
}

provider "google" {
  credentials = base64decode(var.gcp_service_account_key)
  project     = "playground-christerbeke"
  region      = "europe-west4"
  zone        = "europe-west4-a"
}
