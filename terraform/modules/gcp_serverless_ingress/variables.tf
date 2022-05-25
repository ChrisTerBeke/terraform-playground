variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "create_static_ip" {
  type    = bool
  default = true
}

variable "cloud_run_service" {
  type = string
}

variable "domains" {
  type    = list(string)
  default = []
}
