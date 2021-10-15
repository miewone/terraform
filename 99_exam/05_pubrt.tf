resource "aws_route_table" "wgpark_pubrt" {
  vpc_id = aws_vpc.wgpark_vpc.id

  route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.wgpark_ig.id
  }

  tags = {
    Name = "wgpark-pubrt"
  }
}