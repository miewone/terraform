module "gcp_test" {
  source = "../01_module"

  gcp_region = "asia-northeast3"
  gcp_az_list = ["a","b"]
  gcp_subnet_pub_list = ["10.0.0.0/24"]
  gcp_subnet_pri_list = ["10.0.1.0/24"]

  gcp_ssh_user = "ba044"

  gcp_vpc_firewall = [{
    name = "wgpark-firewall-httpssh"

    allow = {
      protocol = "tcp"
      ports = ["80","22"]
    }

#    source_tags = ["web-ssh","web-http"]
  }]
}