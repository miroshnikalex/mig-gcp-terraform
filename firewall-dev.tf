resource "google_compute_firewall" "dev-tcp-allowed" {
  name           = "dev-bastion-to-fleet"
  network        = google_compute_network.custom-dev-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1000
  source_tags    = ["bastion"]
  target_tags    = ["fleet"]
  allow {
    protocol = "tcp"
    ports    = var.dev_tcp_allowed
  }
}

resource "google_compute_firewall" "dev-tcp-denied" {
  name          = "dev-tcp-denied"
  network       = google_compute_network.custom-dev-vpc.name
  direction     = "INGRESS"
  priority      = 1001
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["fleet"]
  deny {
    protocol = "tcp"
    ports    = var.dev_tcp_denied
  }
}
