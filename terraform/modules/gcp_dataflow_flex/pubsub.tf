resource "google_pubsub_topic" "pubsub_topic" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = local.pubsub_topic_name
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = local.pubsub_subsciption_name
  topic   = google_pubsub_topic.pubsub_topic[0].name
}
