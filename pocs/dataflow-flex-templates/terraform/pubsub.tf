resource "google_pubsub_topic" "pubsub_topic" {
  name = "pubsub-topic"
}

resource "google_pubsub_subscription" "pubsub_subscription" {
  name  = "pubsub-subscription"
  topic = google_pubsub_topic.pubsub_topic.name
}
