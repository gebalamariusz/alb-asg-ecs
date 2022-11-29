resource "aws_ecs_task_definition" "nginx-app-task" {
  family       = "nginx-app-task"
  network_mode = "bridge"

  container_definitions = jsonencode([
    {
      name   = "nginx-app"
      image  = "nginxdemos/hello"
      cpu    = 10
      memory = 512
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
}