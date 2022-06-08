variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in."
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

variable "template_storage_url" {
  type        = string
  description = "The location of the Dataflow flex template. Must be of format gs://<bucket>/<path>."
}

variable "max_workers" {
  type    = number
  default = 10
}

variable "extra_roles" {
  type    = list(string)
  default = []
}

variable "job_parameters" {
  type = map(any)
}
