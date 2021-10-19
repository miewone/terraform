resource "aws_placement_group" "wgpark_pg" {
  name                      = "wgpark"
  strategy                  = "cluster"
}

resource "aws_autoscaling_group" "wgpark_auto_group"{
  launch_configuration      = aws_launch_configuration.wgpark_ASG_configuration.name
  vpc_zone_identifier       = [aws_subnet.wgpark_puba.id,aws_subnet.wgpark_pubc.id]
  name                      = "wgpark-at-sg"
  target_group_arns         = [aws_lb_target_group.wgpark_lb_target_group.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  placement_group           = aws_placement_group.wgpark_pg.id
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 4
  force_delete              = true
  tag {
    key                     = "Name"
    value                   = "terraform-asg-example"
    propagate_at_launch     = true      # ?
  }
}