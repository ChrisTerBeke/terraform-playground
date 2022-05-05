data "google_storage_bucket_object" "template_metadata" {
  count = var.enabled ? 1 : 0

  name   = var.template_storage_path
  bucket = var.template_storage_bucket
}

locals {
  dataflow_service_account_roles = [
    "dataflow.worker", "dataflow.admin", // Dataflow mandatory
    "storage.objectViewer",              // container registry image downloads
    // TODO: make roles below this line configurable depending on used template
    "bigquery.dataOwner",                // BigQuery access
    "pubsub.subscriber", "pubsub.viewer" // PubSub access
  ]
}

// TODO: extract service account
resource "google_service_account" "dataflow_service_account" {
  count = var.enabled ? 1 : 0

  project    = var.project_id
  account_id = "${var.name_prefix}-sa"
}

resource "google_project_iam_member" "dataflow_service_account_iam_member" {
  for_each = toset(var.enabled ? local.dataflow_service_account_roles : [])

  project = var.project_id
  member  = "serviceAccount:${google_service_account.dataflow_service_account[0].email}"
  role    = "roles/${each.key}"
}


resource "google_dataflow_flex_template_job" "dataflow_job" {
  count = var.enabled ? 1 : 0

  provider                = google-beta
  project                 = var.project_id
  name                    = "${var.name_prefix}-job"
  region                  = var.region
  container_spec_gcs_path = "gs://${data.google_storage_bucket_object.template_metadata[0].bucket}/${data.google_storage_bucket_object.template_metadata[0].name}"
  on_delete               = "drain"

  parameters = merge({
    subnetwork            = var.vcp_subnet_name
    service_account_email = google_service_account.dataflow_service_account[0].email
    max_num_workers       = var.max_workers
    metadata_file_md5     = data.google_storage_bucket_object.template_metadata[0].md5hash // triggers re-deployment when template is updated via Cloud Build
  }, var.job_parameters)
}
