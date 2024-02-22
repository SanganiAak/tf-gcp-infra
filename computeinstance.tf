resource "google_compute_instance" "webapp_instance" {
  count        = var.var_count
  name         = "${var.app_name}-instance-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.size
    }
  }

  network_interface {
    network    = google_compute_network.vpc[count.index].id
    subnetwork = google_compute_subnetwork.webapp[count.index].id
    access_config {}
  }

  tags = ["webapp-instance", "http-server"]
}
