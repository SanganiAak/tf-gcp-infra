resource "google_pubsub_topic" "verifyemail" {
  name = "verify_email"
}

resource "google_pubsub_subscription" "verifyemail" {
  name  = "verify-email-subscription"
  topic = google_pubsub_topic.verifyemail.id

  ack_deadline_seconds = 20
}
