data "terraform_remote_state" "wgpark-gcs" {
  backend = "gcs"
  config  = {
    bucket = "wgpark-global-gcs"
    prefix = "wgpark-tf"
  }
}
provider "google" {
  region  = local.region
  project = local.project
}
locals {
  project = "cloudexperience"
  env     = "wgpark"
  stage   = "dev"
  name    = "${local.project}-${local.env}-${local.stage}"
  region  = "asia-northeast3"
}

resource "google_compute_network" "wgpark-vpc" {

  name                    = "${local.name}-vpc"
  #  project = local.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wgpark-subnet-pub" {
  #  project = local.project
  count         = length(var.sub-pubs)
  name          = "${local.name}-subnet-pub"
  #  region = local.region
  network       = google_compute_network.wgpark-vpc.name
  ip_cidr_range = var.sub-pubs[count.index]
}

resource "google_compute_subnetwork" "wgpark-subnet-pri" {
  #  project = local.project
  count         = length(var.sub-pris)
  name          = "${local.name}-subnet-pri"
  #  region = local.region
  network       = google_compute_network.wgpark-vpc.name
  ip_cidr_range = var.sub-pris[count.index]
}