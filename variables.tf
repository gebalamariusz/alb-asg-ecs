variable "azs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "common_ports" {
  type = list(number)
}

variable "alb_ports" {
  type = list(number)
}