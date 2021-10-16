resource "aws_vpc" "wgpark_vpc" {
      cidr_block = "192.168.0.0/16"
      instance_tenancy = "default"

      tags = {
            Name = "wgpark-vpc"
      }
}