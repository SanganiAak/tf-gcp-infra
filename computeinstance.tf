# resource "google_compute_instance" "webapp_instance" {
#   # count        = var.var_count
#   name         = "${var.app_name}-instance"
#   machine_type = var.machine_type
#   zone         = var.zone

#   boot_disk {
#     initialize_params {
#       image = var.machine_image
#       size  = var.size
#     }
#   }

#   network_interface {
#     network    = google_compute_network.vpc.id
#     subnetwork = google_compute_subnetwork.webapp.id
#     access_config {}
#   }
#   depends_on = [google_sql_user.users]
#   tags       = ["webapp-instance", "http-server"]

#   metadata_startup_script = templatefile("${path.module}/startup_script.sh.tpl", {
#     username = google_sql_user.users.name
#     password = random_password.password.result
#     database = google_sql_database.database.name
#     host     = google_sql_database_instance.mysql.private_ip_address
#     port     = "3000"
#   })

#   # allow_stopping_for_update = true
#   service_account {
#     scopes = ["https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/cloud-platform"]
#     email  = google_service_account.service_account.email
#   }
# }
