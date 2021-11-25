locals {
  project = "cloudexperience"
  env     = "k8s"
  stage   = "dev"
  name    = "${local.project}-${local.env}-${local.stage}"
  region  = "asia-northeast3"
}

provider "google" {
  credentials = file("../../keys/cloudexperience-58fb82c5a542.json")
  region      = local.region
  project     = local.project
}

resource "google_compute_network" "wgpark-vpc" {
  name                    = "${local.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wgpark-subnet-pub" {
#  count         = length(var.gcpSubnetPub)
  name          = "${local.name}-subnetpub"
  network       = google_compute_network.wgpark-vpc.name
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "wgpark-subnet-pri" {
#  count         = length(var.gcpSubnetPri)
  name          = "${local.name}-subnetpri"
  network       = google_compute_network.wgpark-vpc.name
#  ip_cidr_range = var.gcpSubnetPri[count.index]
  ip_cidr_range = "10.0.2.0/24"
}
resource "google_compute_router" "wgpark-router" {
  name    = "${local.name}-route"
  network = google_compute_network.wgpark-vpc.id
  region  = local.region
}
resource "google_compute_router_nat" "wgpark-nat" {
  name                               = "${local.name}-router-nat"
  router                             = google_compute_router.wgpark-router.name
  region                             = google_compute_router.wgpark-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
resource "google_container_cluster" "wgpark-gke-cluster" {
  name     = "${local.name}-gke"
  location = "${ local.region }-a"

  remove_default_node_pool = true
  initial_node_count       = 1

  default_max_pods_per_node = 110

  private_cluster_config {
    enable_private_endpoint = false
    master_ipv4_cidr_block  = ""
  }
  network    = google_compute_network.wgpark-vpc.id
  subnetwork = google_compute_subnetwork.wgpark-subnet-pri.id
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${local.name}-nodepool-default"
  cluster    = google_container_cluster.wgpark-gke-cluster.id
  node_count = 3



  node_config {
    machine_type = "e2-medium"
    image_type   = "cos_containerd"
    disk_size_gb = 100
    disk_type    = "pd-standard"
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}