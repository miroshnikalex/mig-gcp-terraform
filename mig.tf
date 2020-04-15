resource "google_compute_instance_template" "webserver" {
  name_prefix = "dev-web-"
  description = "Template for MIG of web servers. CentOS + Apache"
  tags        = ["webserver", "migweb"]
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

resource "google_compute_health_check" "web-autohealing" {
  name                = "web-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_http_health_check" "webservers" {
  name                = "dev-web-http-hc"
  request_path        = "/"
  check_interval_sec  = "5"
  timeout_sec         = "5"
  healthy_threshold   = "5"
  unhealthy_threshold = "3"
}

resource "google_compute_target_pool" "webserver" {
  name             = "dev-webservers"
  session_affinity = "CLIENT_IP"
  health_checks    = [google_compute_http_health_check.webservers.name]
}

resource "google_compute_region_instance_group_manager" "webserver" {
  name                      = "webserver-igm"
  base_instance_name        = "dev-web"
  region                    = var.gcp_region
  distribution_policy_zones = [var.gcp_zone, var.gcp_zone2]

  version {
    instance_template = google_compute_instance_template.webserver.self_link
  }

  target_pools = [google_compute_target_pool.webserver.self_link]
  target_size  = 4

  named_port {
    name = "custom"
    port = 8080
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web-autohealing.self_link
    initial_delay_sec = 300
  }

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    #    max_surge_percent            = 20
    max_unavailable_fixed = 2
    min_ready_sec         = 60
  }
}
