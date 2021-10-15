resource "aws_subnet" "sub-puba" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "sub-pub-a"
  }
}
resource "aws_subnet" "sub-pria" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub-pri-a"
  }
}
resource "aws_subnet" "sub-pubb" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "sub-pub-b"
  }
}

resource "aws_subnet" "sub-prib" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "sub-pri-b"
  }
}