locals {
  vpc_network_name                    = "${var.name_prefix}-network"
  vpc_subnet_name                     = "${var.name_prefix}-subnet"
  vpc_subnet_cidr_range               = "${var.vpc_subnet_ip_block}/16"
  dataflow_job_name                   = "${var.name_prefix}-job"
  pubsub_topic_name                   = "${var.name_prefix}-topic"
  pubsub_subsciption_name             = "${var.name_prefix}-subscription"
  bigquery_dataset_id                 = "${replace(var.name_prefix, "-", "_")}_dataset"
  bigquery_table_id                   = "${replace(var.name_prefix, "-", "_")}_table"
  cloudbuild_trigger_name             = "${var.name_prefix}-dataflow-template-trigger"
  template_image_name                 = "${var.name_prefix}-dataflow-template-image"
  storage_bucket_name                 = "${var.name_prefix}-dataflow-storage"
  storage_template_metadata_file_path = "dataflow-flex-templates/${var.name_prefix}/metadata.json"
}
