resource "google_compute_firewall" "lnd-ssh-allow" {
  name           = "lnd-ssh-allow"
  network        = google_compute_network.custom-lnd-vpc.name
  direction      = "INGRESS"
  enable_logging = true
  priority       = 1000
  source_ranges  = ["0.0.0.0/0"]
  target_tags    = ["bastion"]
  allow {
    protocol = "tcp"
    ports    = var.lnd_allowed_tcp_ports
  }
}

resource "google_compute_firewall" "lnd-icmp-allow" {
  name           = "lnd-icmp-allow"
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
