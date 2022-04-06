variable "gcp_org_id" {
  description = "The GCP organization ID."
  type        = string
}

variable "gcp_billing_account" {
  description = "The GCP billing account ID."
  type        = string
}

variable "gcp_default_region" {
  description = "The default GCP region to deploy resources in."
  type        = string
}
