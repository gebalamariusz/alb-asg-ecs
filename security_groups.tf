resource "aws_security_group" "sg-common-ports" {
  name        = "common-ports-sg"
  description = "Allow SSH, Http, Https"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.common_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_network_interface_sg_attachment" "bastion-host-sg-attach" {
  security_group_id    = aws_security_group.sg-common-ports.id
  network_interface_id = aws_instance.bastion-host.primary_network_interface_id
}

resource "aws_security_group" "alb-ports" {
  name        = "alb-ports"
  description = "allow 80, 443 to ALB"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}