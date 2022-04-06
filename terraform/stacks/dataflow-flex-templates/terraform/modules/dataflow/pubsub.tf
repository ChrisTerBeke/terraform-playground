resource "google_pubsub_topic" "pubsub_topic" {
  name = local.pubsub_topic_name
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name  = local.pubsub_subsciption_name
  topic = google_pubsub_topic.pubsub_topic.name
}
