resource "google_storage_bucket" "bucket" {
  name     = "serverless_csye6225"
  location = "US"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./emailverify.zip"
}

resource "google_cloudfunctions_function" "function" {
  name                  = "verify-email"
  description           = "My function triggered by Pub/Sub to verify email"
  runtime               = "python39"
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = var.function_entry_point
  timeout               = 60
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.verifyemail.id
  }

  environment_variables = {
    MAILGUN_DOMAIN  = var.MAILGUN_DOMAIN
    MAILGUN_API_KEY = var.MAILGUN_API_KEY
    BASE_LINK       = var.BASE_LINK
    DB_USER         = google_sql_user.users.name
    DB_PASS         = random_password.password.result
    DB_HOST         = google_sql_database_instance.mysql.private_ip_address
    DB_NAME         = google_sql_database.database.name
  }

  vpc_connector = google_vpc_access_connector.vpc_connector.name
}

resource "google_vpc_access_connector" "vpc_connector" {
  name          = "function-vpc-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.8.0.0/28"
}
