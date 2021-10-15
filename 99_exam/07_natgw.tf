resource "aws_eip" "wgpark_eip_pria" {
      vpc = true
}

resource "aws_eip" "wgpark_eip_pric" {
      vpc = true
}

resource "aws_nat_gateway" "wgpark_ngw_pria" {
  allocation_id   = aws_eip.wgpark_eip_pria.id
  subnet_id       = aws_subnet.wgpark_puba.id

  tags = {
        Name = "wgpark-ngw-pria"
  }
}

resource "aws_nat_gateway" "wgpark_ngw_pric" {
  allocation_id   = aws_eip.wgpark_eip_pric.id
  subnet_id       = aws_subnet.wgpark_pubc.id

  tags = {
        Name = "wgpark-ngw-pric"
  }
  
}