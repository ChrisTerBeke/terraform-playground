variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "account_id" {
  description = "The unique ID of the service account. Can be maximum of 28 characters."
  type        = string

  validation {
    condition     = length(var.sa_id) <= 28
    error_message = "The service account ID must be 28 characters or less."
  }
}

variable "display_name" {
  description = "The name displayed in the Console for this service account."
  type        = string
  default     = null
}

variable "roles" {
  description = "List of roles to attach to the service account."
  type        = list(string)
}
