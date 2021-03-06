variable "project_id" {
  description = "The ID of the GCP project to place the network in."
  type        = string
}

variable "backend_service" {
  type = string
}

variable "iam_members" {
  type    = list(string)
  default = []
}
