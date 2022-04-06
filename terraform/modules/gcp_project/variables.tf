variable "name" {
  description = "The name of the GCP project."
  type        = string
}

variable "project_id" {
  description = "The unique ID of the GCP project."
  type        = string
}

variable "org_id" {
  description = "The ID of the GCP organization that the project lives in."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The ID of the GCP folder that the project lives in."
  type        = string
  default     = null
}

variable "billing_account" {
  description = "The ID of the GCP billing account that the project uses."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the project."
  type        = map(string)
  default     = {}
}

variable "auto_create_network" {
  description = "Whether to create the 'default' VPC network for this project or not."
  type        = bool
  default     = false
}
