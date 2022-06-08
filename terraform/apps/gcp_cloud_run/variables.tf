variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "region" {
  description = "The GCP region to run the Cloud Run service in."
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "image" {
  description = "The registry path to the Docker image to run."
  type        = string
}

variable "domains" {
  type    = list(string)
  default = []
}
