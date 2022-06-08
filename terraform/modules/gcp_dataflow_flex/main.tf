locals {
  dataflow_service_account_roles = concat(["dataflow.worker", "dataflow.admin", "storage.objectViewer"], var.extra_roles)
  template_bucket                = split("/", trimprefix(var.template_storage_url, "gs://"))[0]
  template_path                  = trimprefix(var.template_storage_url, "gs://${local.template_bucket}/")
}

data "google_storage_bucket_object" "template_metadata" {
  name   = local.template_path
  bucket = local.template_bucket
}

// TODO: extract service account
resource "google_service_account" "dataflow_service_account" {
  project    = var.project_id
  account_id = "${var.name_prefix}-sa"
}

resource "google_project_iam_member" "dataflow_service_account_iam_member" {
  for_each = toset(local.dataflow_service_account_roles)

  project = var.project_id
  member  = "serviceAccount:${google_service_account.dataflow_service_account.email}"
  role    = "roles/${each.key}"
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
    service_account_email = google_service_account.dataflow_service_account.email
    max_num_workers       = var.max_workers
    metadata_file_md5     = data.google_storage_bucket_object.template_metadata.md5hash // triggers re-deployment when template is updated via Cloud Build
  }, var.job_parameters)
}
