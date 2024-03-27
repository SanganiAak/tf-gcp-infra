resource "google_pubsub_topic" "verifyemail" {
  name = "verify_email"
}

resource "google_pubsub_subscription" "verifyemail" {
  name  = "verify-email-subscription"
  topic = google_pubsub_topic.verifyemail.id

  ack_deadline_seconds = 20
}

# resource "google_pubsub_topic_iam_binding" "invoker" {
#   topic = google_pubsub_topic.verifyemail.id
#   role  = "roles/pubsub.publisher"

#   members = [
#     "serviceAccount:${google_service_account.service_account.email}",
#   ]
# }
