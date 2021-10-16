resource "aws_instance" "web" {
  ami           = "ami-0e4a9ad2eb120e054"
  instance_type = "t2.micro"

  key_name = "aws_terraform_tf"
  subnet_id = aws_subnet.wgpark_puba.id

  user_data = file("../file/99_install.sh")
  tags = {
    Name = "wgpark-insatnce-wordpress"
  }
}