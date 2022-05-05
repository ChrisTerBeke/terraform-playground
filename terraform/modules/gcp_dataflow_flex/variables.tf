variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "region" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "vcp_subnet_name" {
  type = string
}

variable "template_storage_bucket" {
  type = string
}

variable "template_storage_path" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "max_workers" {
  type    = number
  default = 10
}

variable "job_parameters" {
  type = map(any)
}
