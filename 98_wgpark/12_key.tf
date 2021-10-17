resource "aws_key_pair" "aws_terraform_tf" {
      key_name = "aws_terraform_tf"
      public_key = file("../keys/aws_terraform_tf.pub")
}