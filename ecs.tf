module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.1"

  cluster_name                          = local.name
  default_capacity_provider_use_fargate = false

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = aws_autoscaling_group.asg-nginx-app.arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 3
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }

      default_capacity_provider_strategy = {
        capacity_provider = "one"
        weight            = 1
        base              = 0
      }
    }
  }
}