resource "aws_autoscaling_group" "wgpark_auto_group"{
  launch_configuration  = aws_launch_configuration.wgpark_ASG_configuration.name
  vpc_zone_identifier   = [aws_subnet.wgpark_puba.id,aws_subnet.wgpark_pubc.id]

  target_group_arns     = [aws_lb_target_group.wgpark_lb_target_group.arn]
  health_check_type     = "ELB"

  min_size              = 2
  max_size              = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true      # ?
  }


}