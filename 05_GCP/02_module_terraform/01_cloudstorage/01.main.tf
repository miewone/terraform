resource "google_storage_bucket" "wgpark-bucker" {
  project       = var.gcp_project
  name          = var.bucket_name
  location      = var.gcp_region
  force_destroy = true
  storage_class = var.storage-class
  versioning {
    enabled = true
  }
}