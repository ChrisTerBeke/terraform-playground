resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  name           = "dataflow-build"
  included_files = ["pocs/dataflow-flex-templates/template/**"]

  github {
    owner = "ChrisTerBeke"
    name  = "terraform-playground"

    push {
      branch = "^main$"
    }
  }

  build {
    step {
      id   = "Build docker image"
      name = "gcr.io/kaniko-project/executor:latest"
      args = [
        "--destination=eu.gcr.io/$PROJECT_ID/dataflow/streaming-beam:$COMMIT_SHA",
        "--cache=true",
        "--context=dir://pocs/dataflow-flex-templates/template",
      ]
    }

    step {
      id   = "Store template"
      name = "gcr.io/cloud-builders/gcloud"
      dir  = "pocs/dataflow-flex-templates"
      args = [
        "dataflow", "flex-template", "build",
        "gs://${google_storage_bucket.storage_bucket.name}/${google_storage_bucket_object.dataflow_metadata.name}",
        "--image", "eu.gcr.io/$PROJECT_ID/dataflow/streaming-beam:$COMMIT_SHA",
        "--sdk-language", "PYTHON",
        "--metadata-file", "metadata.json",
      ]
    }
  }
}
