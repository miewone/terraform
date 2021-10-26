module "wgparkTest" {
  source = "../00_structure"
  gcpSubnetPub = ["10.0.0.0/24","10.0.1.0/24"]
  gcpSubnetPri = ["10.0.2.0/24","10.0.3.0/24"]
  gcp-az = ["a","b"]
  gcp-sshkey ="dlsrk489"
}
