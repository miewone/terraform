resource "aws_instance" "aws_instance_key_pair" {
      ami               = "ami-0e4a9ad2eb120e054"
      instance_type     = "t2.small"
      user_data = file("../file/userdata.sh")
      key_name = "aws_terraform_tf"
      tags = {
            Name = "aws-centos-1"
      }
}
resource "aws_key_pair" "aws_terraform_tf" {
      key_name = "aws_terraform_tf"
      public_key = file("../keys/aws_terraform_tf.pub")
}