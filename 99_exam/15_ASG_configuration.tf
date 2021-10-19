

resource "aws_launch_configuration" "wgpark_ASG_configuration" {
  image_id                = var.ami
  instance_type           = "t2.micro"
  key_name                = "aws_terraform_tf"
  iam_instance_profile    = "admin_role"
  security_groups         = [aws_security_group.wgpark_allow_http.id]
  name_prefix             = "wgpark-auto-"
  user_data               = file("../file/99_install.sh")

  lifecycle {
    create_before_destroy = true
  }
}

