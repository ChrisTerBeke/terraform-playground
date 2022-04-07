variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "name" {
  description = "The name of the stack. Used to name all resources."
  type        = string
}

variable "enabled" {
  description = "Whether this stack is enabled or not. A disabled stack will not provision any resources."
  type        = bool
  default     = true
}
