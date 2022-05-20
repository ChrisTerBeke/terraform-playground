variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "revision_name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "revisions" {
  type    = map(string)
  default = {}
}

variable "ingress_annotation" {
  type    = string
  default = "all"
}
