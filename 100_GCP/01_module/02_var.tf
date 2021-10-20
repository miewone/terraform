variable "gcp_ssh_user" {
  description = "GCP 인스턴스 SSH 키 유저"
  type        = string
  default     = "ba044"
}
variable "gcp_region" {
  type = string
}
variable "gcp_az_list" {
  type = list(string)
}
variable "gcp_subnet_pub_list" {
  type = list(string)
}
variable "gcp_subnet_pri_list" {
  type = list(string)
}

variable "gcp_vpc_firewall" {
  type = list(object({
    name = string

    allow = object({
      protocol = string
      ports    = list(string)
    })

#    source_tags = list(string)

#    deny = object({
#      protocol = string
#      ports    = list(string)
#    })
  }))
}
#variable "gce_ssh_pub_key_file" {
#  description = "GCP 인스턴스 SSH PUBLIC 키"
#  type        = string
#  default     = file("../keys/tf-gcp-key.pub")
#}