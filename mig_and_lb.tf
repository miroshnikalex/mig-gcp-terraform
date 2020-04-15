resource "google_compute_forwarding_rule" "dev-webservers" {
  name                  = "dev-webservers-fr"
  provider              = google-beta
  depends_on            = [google_compute_subnetwork.proxy]
  region                = var.gcp_region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.dev-webservers-hp.self_link
  network               = google_compute_network.custom-dev-vpc.self_link
  subnetwork            = google_compute_subnetwork.dev-west2-europe.self_link
  network_tier          = "PREMIUM"
}



resource "google_compute_region_target_http_proxy" "dev-webservers-hp" {
  provider = google-beta
  region   = var.gcp_region
  name     = "dev-webservers-hp"
  url_map  = google_compute_region_url_map.dev-webservers-um.self_link
}



resource "google_compute_region_url_map" "dev-webservers-um" {
  provider        = google-beta
  region          = var.gcp_region
  name            = "dev-webservers-um"
  default_service = google_compute_region_backend_service.dev-webservers-bs.self_link
}



resource "google_compute_region_backend_service" "dev-webservers-bs" {
  provider              = google-beta
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group           = google_compute_region_instance_group_manager.dev-webservers-rigm.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  region        = var.gcp_region
  name          = "dev-website-backend"
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = [google_compute_region_health_check.dev-webservers-hc.self_link]
}



resource "google_compute_region_instance_group_manager" "dev-webservers-rigm" {
  provider = google-beta
  region   = var.gcp_region
  name     = "dev-webservers-rigm-internal"
  version {
    instance_template = google_compute_instance_template.dev-webservers-it.self_link
    name              = "primary"
  }
  base_instance_name = "dev-webservers"
  target_size        = 4
}



resource "google_compute_instance_template" "dev-webservers-it" {
  provider    = google-beta
  name_prefix = "dev-web-"
  description = "Template for MIG of web servers. CentOS + Apache"
  tags        = ["webservers", "load-balanced-backend"]
  labels = {
    environment = "dev"
  }
  machine_type   = "n1-standard-1"
  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.webserver_image
    auto_delete  = true
    boot         = true
    disk_size_gb = var.webserver_image_size
  }

  network_interface {
    network    = google_compute_network.custom-dev-vpc.name
    subnetwork = var.dev_subnet_name1p
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "google_compute_region_health_check" "dev-webservers-hc" {
  depends_on = [google_compute_firewall.dev-webservers-fw3]
  provider   = google-beta
  region     = var.gcp_region
  name       = "dev-webservers-hc"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}



resource "google_compute_firewall" "dev-webservers-fw1" {
  provider      = google-beta
  name          = "dev-webservers-fw-1"
  network       = google_compute_network.custom-dev-vpc.self_link
  source_ranges = [var.dev_subnet_iprange1p]
  allow {
    protocol = "tcp"
    ports    = var.dev_tcp_allowed
  }
  direction = "INGRESS"
}


resource "google_compute_firewall" "dev-webservers-fw2" {
  depends_on    = [google_compute_firewall.dev-webservers-fw1]
  provider      = google-beta
  name          = "dev-webservers-fw-2"
  network       = google_compute_network.custom-dev-vpc.self_link
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["load-balanced-backend"]
  direction   = "INGRESS"
}


resource "google_compute_firewall" "dev-webservers-fw3" {
  depends_on    = [google_compute_firewall.dev-webservers-fw2]
  provider      = google-beta
  name          = "dev-webservers-fw-3"
  network       = google_compute_network.custom-dev-vpc.self_link
  source_ranges = ["10.129.0.0/26"]
  target_tags   = ["load-balanced-backend"]
  allow {
    protocol = "tcp"
    ports    = var.dev_tcp_allowed
  }
  direction = "INGRESS"
}

resource "google_compute_subnetwork" "proxy" {
  provider      = google-beta
  name          = "website-net-proxy"
  ip_cidr_range = "10.129.0.0/26"
  region        = var.gcp_region
  network       = google_compute_network.custom-dev-vpc.self_link
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
}
