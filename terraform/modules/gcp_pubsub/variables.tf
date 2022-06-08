variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "name_prefix" {
  type = string
}

variable "create_subscription" {
  type    = bool
  default = false
}
