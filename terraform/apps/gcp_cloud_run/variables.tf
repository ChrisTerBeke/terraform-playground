variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "regions" {
  description = "The GCP regions to run the Cloud Run service in. Specifying multiple regions results in a highly available setup."
  type        = list(string)
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
