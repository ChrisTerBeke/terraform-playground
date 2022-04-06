variable "name" {
  description = "The name of the VPC network."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Whether to automatically create the subnetworks or not."
  type        = bool
  default     = false
}
