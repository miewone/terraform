resource "aws_launch_configuration" "wgpark_ASG_configuration" {
  image_id        = var.ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.wgpark_allow_http.id]

  user_data       = file("../file/99_install.sh")

  lifecycle {
    create_before_destroy = true
  }

}