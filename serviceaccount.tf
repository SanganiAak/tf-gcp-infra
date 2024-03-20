resource "google_service_account" "service_account" {
  account_id   = "sangani"
  display_name = "Logging Monitoring Service Account"
}

# Assign the Logging Admin role at the project level
resource "google_project_iam_binding" "logging_admin" {
  project = var.project_id
  role    = "roles/logging.logWriter"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_project_iam_binding" "monitoring_metrics_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}
