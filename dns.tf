resource "google_dns_record_set" "a" {
  name         = "sangani.lol."
  managed_zone = "csye6225"
  type         = "A"
  ttl          = 300

  rrdatas    = [google_compute_global_forwarding_rule.default.ip_address]
  depends_on = [google_compute_global_forwarding_rule.default]
}
