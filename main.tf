provider "google" {
  version     = "3.5.0"
  credentials = file(var.cred_file)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "google-beta" {
  credentials = file(var.cred_file)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

terraform {
  backend "gcs" {
    credentials = "local/credentials.json"
    bucket      = "tf-state-bkt-204090"
    prefix      = "terraform/state"
  }
}
