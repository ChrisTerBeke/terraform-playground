locals {
  template_bucket = split("/", trimprefix(var.template_storage_url, "gs://"))[0]
  template_path   = trimprefix(var.template_storage_url, "gs://${local.template_bucket}/")
}

data "google_storage_bucket_object" "template_metadata" {
  name   = local.template_path
  bucket = local.template_bucket
}

module "dataflow_service_account" {
  source = "../gcp_service_account"

  project_id = var.project_id
  account_id = "${var.name_prefix}-sa"
  roles      = concat(["dataflow.worker", "dataflow.admin", "storage.objectViewer"], var.extra_roles)
}

resource "google_dataflow_flex_template_job" "dataflow_job" {
  provider                = google-beta
  project                 = var.project_id
  name                    = "${var.name_prefix}-job"
  region                  = var.region
  container_spec_gcs_path = "gs://${data.google_storage_bucket_object.template_metadata.bucket}/${data.google_storage_bucket_object.template_metadata.name}"
  on_delete               = "drain"

  parameters = merge({
    subnetwork            = var.vcp_subnet_name
    service_account_email = module.dataflow_service_account.email
    max_num_workers       = var.max_workers
    metadata_file_md5     = data.google_storage_bucket_object.template_metadata.md5hash // triggers re-deployment when template is updated via Cloud Build
  }, var.job_parameters)
}
