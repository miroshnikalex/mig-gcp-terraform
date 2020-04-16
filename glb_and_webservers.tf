resource "google_compute_global_address" "dev-web-glb" {
  name         = "dev-web-glb"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}


resource "google_compute_global_forwarding_rule" "dev-web-gfr" {
  name                  = "dev-web-gfr"
  ip_address            = google_compute_global_address.dev-web-glb.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.dev-web-hp.self_link
  load_balancing_scheme = "EXTERNAL"
}


resource "google_compute_target_http_proxy" "dev-web-hp" {
  name    = "dev-web-hp"
  url_map = google_compute_url_map.dev-web-um.self_link
}

resource "google_compute_url_map" "dev-web-um" {
  name            = "dev-web-um"
  default_service = google_compute_backend_service.dev-web-be.self_link
}


resource "google_compute_backend_service" "dev-web-be" {
  provider              = google-beta
  name                  = "dev-web-be"
  protocol              = "HTTP"
  port_name             = "dev-webservers"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL"
  session_affinity      = "CLIENT_IP"
  health_checks         = [google_compute_http_health_check.dev-web-hc.self_link]

  backend {
    group           = google_compute_region_instance_group_manager.dev-webservers-rigm.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_http_health_check" "dev-web-hc" {
  name                = "dev-web-hc"
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout_sec         = 5
  port                = 80
  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_region_instance_group_manager" "dev-webservers-rigm" {
  provider = google-beta
  region   = var.gcp_region
  name     = "dev-webservers-rigm"
  version {
    instance_template = google_compute_instance_template.dev-webservers-it.self_link
    name              = "primary"
  }
  base_instance_name = "dev-webservers"
  target_size        = var.dev-web-mig-size
}

resource "google_compute_instance_template" "dev-webservers-it" {
  provider    = google-beta
  name_prefix = "dev-web-"
  description = "Template for MIG of web servers. CentOS + Apache"
  tags        = ["dev-webservers"]
  labels = {
    environment = "dev"
  }
  machine_type   = var.dev-web-vm
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


resource "google_compute_firewall" "dev-webservers-hc" {
  name        = "dev-webservers-hc"
  network     = google_compute_network.custom-dev-vpc.self_link
  description = "allow Google health checks"
  priority    = 2000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["dev-webservers"]
}
