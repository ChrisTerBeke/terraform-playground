output "topic_id" {
  value = google_pubsub_topic.topic.id
}

output "subscription_id" {
  value = coalescelist(google_pubsub_subscription.subscription.*.id, [""])[0]
}
