resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.wgpark_pc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Main"
  }
}