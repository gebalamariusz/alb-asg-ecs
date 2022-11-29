resource "aws_autoscaling_group" "asg-nginx-app" {
  name     = "asg-nginx-app"
  max_size = 4
  min_size = 1
  //desired_capacity      = 1
  vpc_zone_identifier   = module.vpc.private_subnets
  protect_from_scale_in = true
  //target_group_arns = [aws_lb_target_group.asg-target-group.arn]
  launch_template {
    id      = aws_launch_template.nginx-app-launch-template.id
    version = aws_launch_template.nginx-app-launch-template.latest_version
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}