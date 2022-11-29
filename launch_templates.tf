resource "aws_launch_template" "nginx-app-launch-template" {
  name          = "nginx-app-launch-template"
  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = "t3.medium"
  key_name      = aws_key_pair.ec2-key.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.vpc.default_security_group_id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 30
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "nginx-app"
    }
  }

  user_data = base64encode(local.user_data)
}