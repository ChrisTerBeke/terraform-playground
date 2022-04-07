resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  project        = var.project_id
  name           = local.cloudbuild_trigger_name
  included_files = ["${var.template_directory}/**"]

  github {
    owner = local.github_repo_owner
    name  = local.github_repo_name

    push {
      branch = "^${local.github_repo_branch}$"
    }
  }

  build {
    step {
      id   = "Build Dataflow flex template image"
      name = "gcr.io/kaniko-project/executor:latest"
      args = [
        "--destination=eu.gcr.io/$PROJECT_ID/${local.template_image_name}:$COMMIT_SHA",
        "--cache=true",
        "--context=dir://${local.template_source_code_directory}",
      ]
    }

    step {
      id   = "Store Dataflow flex template"
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "dataflow", "flex-template", "build",
        "gs://${google_storage_bucket.storage_bucket.name}/${google_storage_bucket_object.dataflow_metadata.name}",
        "--image", "eu.gcr.io/$PROJECT_ID/${local.template_image_name}:$COMMIT_SHA",
        "--sdk-language", "PYTHON",
        "--metadata-file", "${local.template_metadata_file_path}",
      ]
    }
  }
}
