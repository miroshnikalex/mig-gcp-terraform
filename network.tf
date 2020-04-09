resource "google_compute_subnetwork" "lnd-west2-europe" {
  name          = var.lnd_subnet_name1p
  ip_cidr_range = var.lnd_subnet_iprange1p
  region        = var.gcp_region
  network       = google_compute_network.custom-lnd-vpc.self_link
  secondary_ip_range {
    range_name    = var.lnd_subnet_name1p
    ip_cidr_range = var.lnd_subnet_iprange1s
  }
}


resource "google_compute_network" "custom-lnd-vpc" {
  name                    = var.lnd_network_name
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "dev-west2-europe" {
  name          = var.dev_subnet_name1p
  ip_cidr_range = var.dev_subnet_iprange1p
  region        = var.gcp_region
  network       = google_compute_network.custom-dev-vpc.self_link
  secondary_ip_range {
    range_name    = var.dev_subnet_name1s
    ip_cidr_range = var.dev_subnet_iprange1s
  }
}

resource "google_compute_network" "custom-dev-vpc" {
  name                    = var.dev_network_name
  auto_create_subnetworks = false
}

resource "google_compute_address" "bastion-ip" {
  name         = "bastion-ext-ip"
  address_type = "EXTERNAL"
  region       = var.gcp_region
}
