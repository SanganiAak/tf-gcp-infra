output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "webapp_subnet_id" {
  value = google_compute_subnetwork.webapp.id
}

output "db_subnet_id" {
  value = google_compute_subnetwork.db.id
}

output "google_compute_instance_id" {
  value = google_compute_instance.webapp_instance.id
}
