data "google_storage_bucket_object" "template_metadata" {
  count = var.enabled ? 1 : 0

  name   = var.template_storage_path
  bucket = var.template_storage_bucket
}

resource "google_service_account" "dataflow_service_account" {
  count = var.enabled ? 1 : 0

  project    = var.project_id
  account_id = local.dataflow_service_account_name
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
  name                    = local.dataflow_job_name
  region                  = google_compute_subnetwork.vpc_subnetwork[0].region
  container_spec_gcs_path = "gs://${data.google_storage_bucket_object.template_metadata[0].bucket}/${data.google_storage_bucket_object.template_metadata[0].name}"
  on_delete               = "drain"

  parameters = {
    input_subscription    = google_pubsub_subscription.pubsub_subscription[0].id
    output_table          = "${var.project_id}:${google_bigquery_dataset.bigquery_dataset[0].dataset_id}.${google_bigquery_table.bigquery_table[0].table_id}"
    subnetwork            = "regions/${google_compute_subnetwork.vpc_subnetwork[0].region}/subnetworks/${google_compute_subnetwork.vpc_subnetwork[0].name}"
    service_account_email = google_service_account.dataflow_service_account[0].email
    max_num_workers       = var.dataflow_max_workers
    metadata_file_md5     = data.google_storage_bucket_object.template_metadata[0].md5hash // triggers re-deployment when template is updated via Cloud Build
  }
}
