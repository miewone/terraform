resource "aws_lb" "wgpark_lb" {
  name                = "wgpark-asg-example"
  load_balancer_type  = "application"

  subnets             = [aws_subnet.wgpark_puba.id,aws_subnet.wgpark_pubc.id]
  security_groups     = [aws_security_group.wgpark_alb.id]


}

resource "aws_lb_listener" "wgpark_http" {
  load_balancer_arn   = aws_lb.wgpark_lb.arn
  port                = 80
  protocol            = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wgpark_lb_target_group.arn
#    fixed_response {
#      content_type    = "text/plain"
#      message_body    = "404: page not found"
#      status_code     = 404
#    }
  }
}

resource "aws_lb_target_group" "wgpark_lb_target_group" {
  name        = "wgpark-lb-target-group"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.wgpark_vpc.id

  health_check {
    enabled   = true
    path      = "/"
    protocol  = "HTTP"
    matcher   = "200"
    port      = "traffic-port"
    interval  = 15
    timeout   = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "wgpark_lb_tg_ass_a" {
  target_group_arn = aws_lb_target_group.wgpark_lb_target_group.arn
  target_id        = aws_instance.web.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "wgpark_lb_tg_ass_c" {
  target_group_arn = aws_lb_target_group.wgpark_lb_target_group.arn
  target_id        = aws_instance.web.id
  port             = 80
}

#resource "aws_lb_listener_rule" "wgpark_lb_rule" {
#  listener_arn  = aws_lb_listener.wgpark_http.arn
#  priority      = 100
#
#  condition {
#    path_pattern {
#      values = ["*"]
#    }
#  }
#
#  action {
#    type  = "forward"
#    target_group_arn = aws_lb_target_group.wgpark_lb_target_group.arn
#  }
#}

output "alb_dns_name"{
  value = aws_lb.wgpark_lb.dns_name
  description = "The domain name of the load balancer"
}