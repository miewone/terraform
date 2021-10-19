resource "aws_instance" "wgaprk_insatnce_a" {
  ami           = var.ami
  instance_type = "t2.micro"

  key_name = "aws_terraform_tf"
  subnet_id = aws_subnet.wgpark_puba.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.wgpark_allow_http.id]
  user_data = file("../file/99_install.sh")
  tags = {
    Name = "wgpark-insatnce-wordpress"
  }
}
resource "aws_instance" "wgpark_insatnce_c" {
  ami           = var.ami
  instance_type = "t2.micro"

  key_name = "aws_terraform_tf"
  subnet_id = aws_subnet.wgpark_puba.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.wgpark_allow_http.id]
  user_data = file("../file/99_install.sh")
  tags = {
    Name = "wgpark-insatnce-wordpress"
  }
}
output "instance-id" {
  value = aws_instance.web.id
}
output "instance-pubip"{
  value = aws_instance.web.public_ip
}