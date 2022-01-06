variable "gcp_service_account_key" {
  description = "The GCP Service Account Key that Terraform will use to apply infrastructure changes. Should be base64 encoded."
  sensitive   = true
}
