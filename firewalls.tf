resource "google_compute_firewall" "allow_http_3000" {
  # count       = var.var_count
  name        = "${var.app_name}-allow"
  network     = google_compute_network.vpc.id
  direction   = "INGRESS"
  priority    = 1000
  target_tags = ["http-server"]

  allow {
    protocol = "tcp"
    ports    = ["${var.webapp_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny_ssh" {
  # count     = var.var_count
  name      = "${var.app_name}-deny-ssh"
  network   = google_compute_network.vpc.id
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "database_allow" {
  name      = "database-allow-port"
  network   = google_compute_network.vpc.id
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["0.0.0.0/0"]
}
