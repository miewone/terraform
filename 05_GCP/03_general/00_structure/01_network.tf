locals {
  project = "cloudexperience"
  env     = "wgpark"
  stage   = "dev"
  name    = "${local.project}-${local.env}-${local.stage}"
  region  = "asia-northeast3"
}

provider "google" {
  credentials = file("E:/OneDrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/cloudexperience-58fb82c5a542.json")
  region      = local.region
  project     = local.project
}

resource "google_compute_network" "wgpark-vpc" {
  name                    = "${local.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wgpark-subnet-pub" {
  count         = length(var.gcpSubnetPub)
  name          = "${local.name}-subnetpub${count.index}"
  network       = google_compute_network.wgpark-vpc.name
  ip_cidr_range = var.gcpSubnetPub[count.index]
}

resource "google_compute_subnetwork" "wgpark-subnet-pri" {
  count         = length(var.gcpSubnetPri)
  name          = "${local.name}-subnetpri${count.index}"
  network       = google_compute_network.wgpark-vpc.name
  ip_cidr_range = var.gcpSubnetPri[count.index]
}

resource "google_compute_instance" "wgpark-bastioninstance" {
  name         = "${local.name}-bastion"
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
    ssh-keys = "${var.gcp-sshkey}:${file("E:/OneDrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/tf-gcp-key.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "centos-7-v20210916"
      size  = "20"
    }
  }
}

resource "google_compute_instance_template" "wgpark-template-front" {
  name = "${local.name}-instancetemplate"

  tags = ["instancetemplate"]

  labels = {
    environment = "dev"
  }

  machine_type = "e2-small"

  disk {
    source_image = "centos-7-v20210916"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.wgpark-vpc.id
    subnetwork = google_compute_subnetwork.wgpark-subnet-pub[0].id
  }

  metadata = {
    ssh-keys = "${var.gcp-sshkey}:${file("E:/OneDrive/OneDrive - 동명대학교/99_베스핀교육/Bespin_EDU/13_Terraform/keys/tf-gcp-key.pub")}"
  }
  #  require
  #  dick,machine_type,networkinterface
  #
}

resource "google_compute_instance_group_manager" "wgpark-instance-group" {
  # require
  # base_insatance_name ,version ,name, zone
  name = "${local.name}-igm"

  base_instance_name = "wgpark-autoscaling"

  # zone을 리전별로할려면 사용할 모든 가용존을 주면됨.
  #  zone = ["${local.region}${var.gcp-az[0]}","${local.region}${var.gcp-az[1]}"]
  zone = "asia-northeast3-a"
  version {
    instance_template = google_compute_instance_template.wgpark-template-front.id
  }


  named_port {
    name = "http"
    port = "80"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.wgpark-autohealing.id
    initial_delay_sec = 10
  }
}

resource "google_compute_health_check" "wgpark-autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}