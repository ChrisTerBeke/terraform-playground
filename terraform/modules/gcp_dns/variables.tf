variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in."
  type        = string
}

variable "zone_name" {
  type = string
}

variable "domain" {
  type = string
}

variable "a_records" {
  type    = map(list(string))
  default = {}
}
