output "topic_id" {
  value = coalescelist(google_pubsub_topic.topic.*.id, [""])[0]
}

output "subscription_id" {
  value = coalescelist(google_pubsub_subscription.subscription.*.id, [""])[0]
}
