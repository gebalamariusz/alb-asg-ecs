resource "aws_lb" "alb-nginx-app" {
  name               = "alb-nginx-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-ports.id, module.vpc.default_security_group_id]
  subnets            = module.vpc.public_subnets
}

#Target groups
resource "aws_lb_target_group" "asg-target-group" {
  name        = "nginx-app-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.alb-nginx-app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener-https" {
  load_balancer_arn = aws_lb.alb-nginx-app.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Something went wrong"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_rule" "https-rule-nginx-app" {
  listener_arn = aws_lb_listener.listener-https.arn
  priority     = 100

  action {
    target_group_arn = aws_lb_target_group.asg-target-group.arn
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}