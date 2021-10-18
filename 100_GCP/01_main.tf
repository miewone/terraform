provider "google" {
  credentials = "${file("../keys/cloudexperience-58fb82c5a542.json")}"
  project = "cloudexperience"
  region  = "asia-northeast3"
  zone    = "asia-northeast3-a"
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

resource "google_compute_firewall" "wgpark_firewall" {
  name          = "wgpark-firewall"
  network       = google_compute_network.vpc_network.name

  allow {
    protocol    = "tcp"
    ports       = ["80","22"]
  }
  source_tags   = ["web-ssh"]
}
resource "google_compute_instance" "wgpark_instance" {
  name          = "wgparkinstance"
  machine_type  = "e2-micro"
  zone          = "asia-northeast3-a"

  tags          = ["wgpark-tf"]

  metadata_startup_script =<<-EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
                            EOF
  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.wgpark_subent_pub.id

    access_config {

    }
  }
  boot_disk {
    initialize_params {
      image     = "centos-7-v20210916"
      size      = "20"
    }
  }

}