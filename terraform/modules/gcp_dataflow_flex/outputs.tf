output "pubsub_topic_id" {
  value = coalescelist(google_pubsub_topic.pubsub_topic.*.id, [""])[0]
}
