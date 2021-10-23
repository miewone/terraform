terraform {
  required_version = ">=0.12"

  backend "gcs" {
    bucket = "wgpark-global-gcs"
    prefix = "wgpark-tf"
  }
}

provider "google" {
  credentials = file(var.gcp_auth_file)
  project     = var.gcp_project
  region      = var.gcp_region
}