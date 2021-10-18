provider "google" {
  project = "cloudexperience"
  region  = "asia-northeast3"
}

resource "google_compute_network" "vpc_network" {
  name = "wgpark-vpcnetwork"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wgpark_subent_pub" {
  name          = "wgaprk-subnet-pub"
  ip_cidr_range = "10.0.0.0/24"
  region        = "asia-northeast3"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "wgpark_subent_pri" {
  name          = "wgaprk-subnet-pri"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-northeast3"
  network       = google_compute_network.vpc_network.id
}

