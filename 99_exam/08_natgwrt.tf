resource "aws_route_table" "wgpark_natrt_pria" {
  vpc_id = aws_vpc.wgpark_vpc.id

  route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_nat_gateway.wgpark_ngw_pria.id
  }

  tags = {
    Name = "wgpark-natrt-pria"
  }
}

resource "aws_route_table" "wgpark_natrt_pric" {
  vpc_id = aws_vpc.wgpark_vpc.id

  route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_nat_gateway.wgpark_ngw_pric.id
  }

  tags = {
    Name = "wgpark-natrt-pric"
  }
}