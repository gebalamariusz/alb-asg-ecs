resource "aws_ecs_service" "nginx-app-svc" {
  name            = "nginx-app-svc"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.nginx-app-task.arn
  desired_count   = 3

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  capacity_provider_strategy {
    capacity_provider = "one"
    weight            = 1
    base              = 0
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.asg-target-group.arn
    container_name   = "nginx-app"
    container_port   = 80
  }
}