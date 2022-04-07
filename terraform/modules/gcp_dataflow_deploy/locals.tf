locals {
  cloudbuild_trigger_name             = "${var.name_prefix}-dataflow-template-trigger"
  template_image_name                 = "${var.name_prefix}-dataflow-template-image"
  storage_bucket_name                 = "${var.name_prefix}-dataflow-storage"
  storage_template_metadata_file_path = "dataflow-flex-templates/${var.name_prefix}/metadata.json"
  github_repo_location                = split(":", var.template_github_repository)[0]
  github_repo_branch                  = split(":", var.template_github_repository)[1]
  github_repo_owner                   = split("/", local.github_repo_location)[0]
  github_repo_name                    = split("/", local.github_repo_location)[1]
  template_metadata_file_path         = "${var.template_directory}/${var.template_metadata_file_path}"
  template_source_code_directory      = "${var.template_directory}/${var.template_source_code_directory}"
}
