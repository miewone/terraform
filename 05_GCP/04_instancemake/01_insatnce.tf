locals {
  project = "2-PARKWONGYUN-01"
  env     = "wgpark"
  stage   = "dev"
  name    = "${local.project}-${local.env}-${local.stage}"
  region  = "asia-northeast3"
}
data "google" "" {}
variable "gcpSubnetPub" {

}
provider "google" {
  credentials = file("../../../keys/parkwongyun-01-eea1a5c6ef0d.json")
  region      = local.region
  project     = local.project
}

#resource "google_compute_network" "wgpark-vpc" {
#  name                    = "${local.name}-vpc"
#  auto_create_subnetworks = false
#}

#resource "google_compute_subnetwork" "wgpark-subnet-pub" {
#  count         = length(var.gcpSubnetPub)
#  name          = "${local.name}-subnetpub${count.index}"
#  network       = google_compute_network.
#  ip_cidr_range = var.gcpSubnetPub[count.index]
#}

#resource "google_compute_subnetwork" "wgpark-subnet-pri" {
#  count         = length(var.gcpSubnetPri)
#  name          = "${local.name}-subnetpri${count.index}"
#  network       = google_compute_network.wgpark-vpc.name
#  ip_cidr_range = var.gcpSubnetPri[count.index]
#}
resource "google_compute_firewall" "wgpark-firewall" {
  name    = "wgpark-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_instance" "wgpark-bastioninstance" {
  name         = "${local.name}-control"
  machine_type = "e2-micro"
  zone         = "${local.region}-${var.gcp-az[0]}"

  tags = ["bastion"]

  network_interface {
    network    = google_compute_network.wgpark-vpc.id
    subnetwork = google_compute_subnetwork.wgpark-subnet-pub[0].id

    access_config {

    }
  }
  metadata = {
    ssh-keys = "${var.gcp-sshkey}:${file("../../../keys/tf-gcp-key.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "centos-7-v20210916"
      size  = "20"
    }
  }
}

resource "google_compute_router" "wgpark-router" {
  name    = "my-router"
  network = google_compute_network.wgpark-vpc.id
  region  = local.region
}

resource "google_compute_router_nat" "wgpark-nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.wgpark-router.name
  region                             = google_compute_router.wgpark-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

}


10.178.0.4 servera.example.com  servera
10.178.0.5 serverb.example.com  serverb
10.178.0.6 serverc.example.com  server