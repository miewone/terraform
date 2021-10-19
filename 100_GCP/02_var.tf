variable "gcp_ssh_user" {
  description  = "GCP 인스턴스 SSH 키 유저"
  type    = string
  default = "ba044"
}

#variable "gce_ssh_pub_key_file" {
#  description = "GCP 인스턴스 SSH PUBLIC 키"
#  type        = string
#  default     = file("../keys/tf-gcp-key.pub")
#}