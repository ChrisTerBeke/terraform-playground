resource "google_cloud_scheduler_job" "test_load_scheduler" {
  count = var.enabled ? 1 : 0

  project  = var.project_id
  name     = "${var.name}-load"
  schedule = "* * * * *" // every minute
  region   = "europe-west1"

  pubsub_target {
    topic_name = module.dataflow_simple.pubsub_topic_id
    data       = base64encode(jsonencode({ "url" : "https://christerbeke.com", "review" : "positive" }))
  }
}

resource "google_cloud_scheduler_job" "test_load_scheduler_negative" {
  count = var.enabled ? 1 : 0

  project  = var.project_id
  name     = "${var.name}-load-negative"
  schedule = "*/2 * * * *" // every two minutes
  region   = "europe-west1"

  pubsub_target {
    topic_name = module.dataflow_simple.pubsub_topic_id
    data       = base64encode(jsonencode({ "url" : "https://christerbeke.com", "review" : "negative" }))
  }
}
