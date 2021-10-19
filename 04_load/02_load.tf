resource "aws_lb" "wgpark_lb" {
  name               = "wgpark-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wgpark_alb.id]
  subnets            = [aws_subnet.wgpark_puba.id,aws_subnet.wgpark_pubc.id]

#
#  access_logs {
#    bucket  = aws_s3_bucket.lb_logs.bucket
#    prefix  = "test-lb"
#    enabled = true
#  }

  tags = {
    Env = "test"
  }
}