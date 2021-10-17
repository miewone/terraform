resource "aws_internet_gateway" "wgpark_ig" {
  vpc_id = aws_vpc.wgpark_vpc.id

  tags = {
    Name = "wgpark"
  }
}

output "vpc-id" {
      value = aws_vpc.wgpark_vpc.id
}