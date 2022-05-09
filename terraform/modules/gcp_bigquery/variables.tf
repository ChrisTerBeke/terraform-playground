variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "time_partitioning" {
  type    = string
  default = "DAY"
}

variable "allow_destroy" {
  type    = bool
  default = false
}
