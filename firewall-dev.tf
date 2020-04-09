resource "google_compute_firewall" "dev-ssh-allow" {
  name           = "dev-bastion-to-fleet"
  network        = google_compute_network.custom-dev-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1000
  source_tags    = ["bastion"]
  target_tags    = ["fleet"]
  allow {
    protocol = "tcp"
    ports    = var.dev_allowed_tcp_ports
  }
}
