data "google_project" "current_project" {}

resource "google_dataflow_flex_template_job" "dataflow_job" {
  provider                = google-beta
  name                    = local.dataflow_job_name
  container_spec_gcs_path = "gs://${google_storage_bucket.storage_bucket.name}/${google_storage_bucket_object.dataflow_metadata.name}"

  parameters = {
    input_subscription = google_pubsub_subscription.pubsub_subscription.id
    output_table       = "${data.google_project.current_project.project_id}:${google_bigquery_dataset.bigquery_dataset.dataset_id}.${google_bigquery_table.bigquery_table.table_id}"
    subnetwork         = "regions/${google_compute_subnetwork.vpc_subnetwork.region}/subnetworks/${google_compute_subnetwork.vpc_subnetwork.name}"
    metadata_file_md5  = google_storage_bucket_object.dataflow_metadata.md5hash
  }
}
