resource "google_pubsub_topic" "topic" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = "${var.name_prefix}-topic"
}

resource "google_pubsub_subscription" "subscription" {
  count = var.enabled && var.create_subscription ? 1 : 0

  project = var.project_id
  name    = "${var.name_prefix}-subscription"
  topic   = google_pubsub_topic.topic[0].name
}
