# VPC
resource "google_compute_network" "vpc" {
  count                           = var.var_count
  name                            = "${var.vpc_name}-${count.index}"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

# Subnets
resource "google_compute_subnetwork" "webapp" {
  count         = var.var_count
  name          = "${var.app_name}-${count.index}"
  ip_cidr_range = "10.0.${count.index}.0/24"
  region        = var.region
  network       = google_compute_network.vpc[count.index].id
}

resource "google_compute_subnetwork" "db" {
  count         = var.var_count
  name          = "${var.database}-${count.index}"
  ip_cidr_range = "10.0.${count.index + 100}.0/24"
  region        = var.region
  network       = google_compute_network.vpc[count.index].id
}

# Route for webapp subnet
resource "google_compute_route" "webapp_route" {
  count            = var.var_count
  name             = "webapp-route-${count.index}"
  dest_range       = var.route_dest_range
  network          = google_compute_network.vpc[count.index].id
  next_hop_gateway = var.route_next_hop_gateway
}
