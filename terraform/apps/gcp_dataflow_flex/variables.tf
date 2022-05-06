variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "region" {
  description = "The region to run the Dataflow job in."
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "vcp_subnet_name" {
  description = "The VPC subnetwork in which the resources should run."
  type        = string
}

variable "template_storage_location" {
  type = string
}

variable "template_github_repository" {
  type = string
}

variable "template_directory" {
  type = string
}

variable "enabled" {
  description = "Whether this stack is enabled or not. A disabled app will not provision any resources."
  type        = bool
  default     = true
}
