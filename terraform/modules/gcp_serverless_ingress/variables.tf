variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "name" {
  type = string
}

variable "cloud_run_services" {
  type    = map(string)
  default = {}
}

variable "domains" {
  type    = list(string)
  default = []
}
