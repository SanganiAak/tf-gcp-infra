resource "google_sql_database_instance" "mysql" {
  # provider = google-beta
  name                = var.gcp_mysql
  database_version    = var.database_version
  project             = var.project_id
  deletion_protection = var.deletion_protection
  region              = var.region
  depends_on          = [google_service_networking_connection.private_vpc_connection]
  settings {
    tier              = "db-f1-micro"
    availability_type = var.availability_type
    activation_policy = "ALWAYS"

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

    ip_configuration {
      ipv4_enabled = var.gcp_ipv4_enabled
      private_network = google_compute_network.vpc.id
    }

    disk_type = var.mysql_disk_type
    disk_size = var.mysql_disk_size

    location_preference {
      zone = var.zone
    }

  }
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

resource "google_sql_database" "database" {
  name     = local.sql_database.database
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "users" {
  name     = local.sql_database.user
  instance = google_sql_database_instance.mysql.name
  password = random_password.password.result
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    instance = google_sql_database_instance.mysql.name
  }
}

