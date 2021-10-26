provider "google" {
  credentials = file("D:/onedrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/cloudexperience-58fb82c5a542.json")
  project     = "cloudexperience"
  region      = var.gcp_region
  #  zone    = "asia-northeast3-a"
}
resource "google_compute_network" "vpc_network" {
  name                    = "wgpark-vpcnetwork"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wgpark_subent_pubs" {
  count         = length(var.gcp_subnet_pub_listc04)
  name          = "wgaprk-subnet-pub${count.index}"
  #  ip_cidr_range = "10.0.0.0/24"
  ip_cidr_range = var.gcp_subnet_pub_list[count.index]
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "wgpark_subent_pris" {
  count         = length(var.gcp_subnet_pri_list)
  name          = "wgaprk-subnet-pri${count.index}"
  #  ip_cidr_range = "10.0.1.0/24"
  ip_cidr_range = var.gcp_subnet_pri_list[count.index]
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "wgpark_firewall" {
  count = length(var.gcp_vpc_firewall)
  name    = var.gcp_vpc_firewall[count.index].name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = var.gcp_vpc_firewall[count.index].allow.protocol
    ports    = var.gcp_vpc_firewall[count.index].allow.ports
  }
#  source_tags = var.gcp_vpc_firewall[count.index].source_tags
}
resource "google_compute_instance" "wgpark_bastioninstance" {
  name         = "wgpark-bastion"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-${var.gcp_az_list[0]}"

  tags = ["wgpark-bastionhost"]
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.wgpark_subent_pubs[0].id

    access_config {

    }
  }
  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file("D:/onedrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/tf-gcp-key.pub")}"
  }
  boot_disk {
    initialize_params {
      image = "centos-7-v20210916"
      size  = "20"
    }
  }

}

#resource "google_compute_project_metadata" "wgpark_key" {
#  metadata = {
#    ssh-keys = "${var.gcp_ssh_user}:${file("D:/onedrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/tf-gcp-key.pub")}"
#  }
#}