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
