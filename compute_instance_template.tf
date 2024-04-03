resource "google_compute_region_instance_template" "webapp_template" {
  name_prefix  = "${var.app_name}-template"
  machine_type = var.machine_type

  disk {
    source_image = var.machine_image
    auto_delete  = true
    boot         = true
    disk_size_gb = var.size
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.webapp.id

    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/startup_script.sh.tpl", {
    username = google_sql_user.users.name
    password = random_password.password.result
    database = google_sql_database.database.name
    host     = google_sql_database_instance.mysql.private_ip_address
    port     = "3000"
  })

  service_account {
    scopes = ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/cloud-platform"]
    email  = google_service_account.service_account.email
  }

  tags = ["webapp-instance", "http-server"]
}

resource "google_compute_health_check" "webapp_health_check" {
  name               = "${var.app_name}-health-check"
  check_interval_sec = 30
  timeout_sec        = 10
  http_health_check {
    port         = 3000
    request_path = "/healthz"
  }
}

resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  name   = "${var.app_name}-autoscaler"
  region = var.region

  target = google_compute_region_instance_group_manager.webapp_manager.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.05
    }
  }
}

resource "google_compute_region_instance_group_manager" "webapp_manager" {
  name               = "${var.app_name}-manager"
  region             = var.region
  base_instance_name = var.app_name
  version {
    instance_template = google_compute_region_instance_template.webapp_template.id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp_health_check.id
    initial_delay_sec = 300
  }
  named_port {
    name = "http"
    port = 3000
  }
}
