resource "google_compute_instance" "bastion-vm" {
  name           = "bastion-europe"
  machine_type   = var.bastion_vm_type
  zone           = var.gcp_zone
  can_ip_forward = true
  tags           = ["bastion"]
  boot_disk {
    auto_delete = false
    initialize_params {
      type  = "pd-standard"
      size  = var.bastion_image_size
      image = var.bastion_image
    }
  }
  network_interface {
    network    = google_compute_network.custom-lnd-vpc.name
    subnetwork = var.lnd_subnet_name1p
    network_ip = var.bastion_lnd_ip_internal
    access_config {
      nat_ip = google_compute_address.bastion-ip.address
    }
  }
  network_interface {
    network    = google_compute_network.custom-dev-vpc.name
    subnetwork = var.dev_subnet_name1p
    network_ip = var.bastion_dev_ip_internal
  }
  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
  }
  shielded_instance_config {
    enable_secure_boot = true
  }
}
