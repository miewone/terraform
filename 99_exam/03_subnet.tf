resource "aws_subnet" "wgpark_puba" {
  vpc_id     = aws_vpc.wgpark_vpc.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "pub-a"
  }
}

resource "aws_subnet" "wgpark_pubc" {
  vpc_id     = aws_vpc.wgpark_vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "pub-c"
  }
}

resource "aws_subnet" "wgpark_pria" {
  vpc_id     = aws_vpc.wgpark_vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "pri-a"
  }
}

resource "aws_subnet" "wgpark_pric" {
  vpc_id     = aws_vpc.wgpark_vpc.id
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "pri-c"
  }
}

