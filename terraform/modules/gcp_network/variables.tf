variable "name" {
  description = "The name of the VPC network."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "auto_create_subnetworks" {
  description = "Whether to automatically create the subnetworks or not."
  type        = bool
  default     = false
}

variable "create_subnet" {
  type    = bool
  default = false
}

variable "subnet_region" {
  type    = string
  default = ""
}

variable "subnet_cidr_range" {
  type    = string
  default = "10.2.0.0/16"
}
