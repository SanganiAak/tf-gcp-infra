# Health Check
resource "google_compute_health_check" "health_check" {
  name = "webapp-health-check-lb"
  #   region = var.region
  http_health_check {
    port         = 3000
    request_path = "/healthz"
  }
}

# Backend Service
resource "google_compute_backend_service" "webapp" {
  name = "webapp-backend-service"
  #   region                = var.region
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.health_check.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  backend {
    group           = google_compute_region_instance_group_manager.webapp_manager.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}


# URL Map
resource "google_compute_url_map" "webapp_url" {
  name            = "webapp-url-map"
  default_service = google_compute_backend_service.webapp.id
}

# Target HTTP Proxy
resource "google_compute_target_https_proxy" "webapp_https" {
  name    = "webapp-https-proxy"
  url_map = google_compute_url_map.webapp_url.self_link
  ssl_certificates = [
    google_compute_managed_ssl_certificate.lb_default.name
  ]
}

# Global Address
resource "google_compute_global_address" "webapp" {
  name = "webapp-global-address"
}

# Forwarding Rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "webapp-forwarding-rule"
  target                = google_compute_target_https_proxy.webapp_https.self_link
  port_range            = "443"
  ip_address            = google_compute_global_address.webapp.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_managed_ssl_certificate" "lb_default" {
  name = "webapp-ssl-cert"

  managed {
    domains = ["sangani.lol"]
  }
}
