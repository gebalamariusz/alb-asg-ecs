resource "aws_instance" "bastion-host" {
  ami           = "ami-0a5b5c0ea66ec560d"
  instance_type = "t2.nano"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = aws_key_pair.ec2-key.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    "Name" = "bastion-host"
  }
}