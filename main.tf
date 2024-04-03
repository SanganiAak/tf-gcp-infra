resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  name          = var.app_name
  ip_cidr_range = var.ip_cidr_range_webapp
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "db" {
  name          = var.database
  ip_cidr_range = var.ip_cidr_range_db
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_route" "webapp_route" {
  name             = "webapp-route"
  dest_range       = var.route_dest_range
  network          = google_compute_network.vpc.id
  next_hop_gateway = var.route_next_hop_gateway
}
