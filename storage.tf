resource "google_storage_bucket" "provisioning" {
  name          = var.provisioning_bkt
  location      = "EU"
  force_destroy = true
  versioning {
    enabled = true
  }
}
