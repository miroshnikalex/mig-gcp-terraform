resource "google_compute_firewall" "lnd_tcp_allowed" {
  name           = "lnd-tcp-allowed"
  network        = google_compute_network.custom-lnd-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1000
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["bastion"]
  allow {
    protocol = "tcp"
    ports    = var.lnd_tcp_allowed
  }
}

resource "google_compute_firewall" "lnd-icmp-allowed" {
  name           = "lnd-icmp-allowed"
  network        = google_compute_network.custom-lnd-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1001
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["bastion"]
  allow {
    protocol = "icmp"
  }
}
resource "google_compute_firewall" "lnd_tcp_denied" {
  name           = "lnd-tcp-denied"
  network        = google_compute_network.custom-lnd-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1002
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["bastion"]
  allow {
    protocol = "tcp"
    ports    = var.lnd_tcp_denied
  }
}

resource "google_compute_firewall" "lnd_udp_denied" {
  name           = "lnd-udp-denied"
  network        = google_compute_network.custom-lnd-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1003
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["bastion"]
  allow {
    protocol = "udp"
    ports    = var.lnd_udp_denied
  }
}
