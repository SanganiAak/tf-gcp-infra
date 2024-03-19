resource "google_dns_record_set" "a" {
  name         = "sangani.lol."
  managed_zone = "csye6225"
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.webapp_instance.network_interface[0].access_config[0].nat_ip]
depends_on = [ google_compute_instance.webapp_instance ]
}
