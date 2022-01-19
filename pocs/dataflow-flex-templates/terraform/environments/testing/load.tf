resource "google_cloud_scheduler_job" "test_load_scheduler" {
  name     = "ctb-test-load"
  schedule = "* * * * *" // every minute
  region   = "europe-west1"

  pubsub_target {
    topic_name = module.dataflow_simple.pubsub_topic_id
    data = base64encode(jsonencode({"url": "https://christerbeke.com", "review": "positive"}))
  }
}
