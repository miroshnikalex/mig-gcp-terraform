provider "google" {
  version     = "3.5.0"
  credentials = file(var.cred_file)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
