resource "aws_vpc" "vpc_abdiel_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name  = "vpc_abdiel_virginia"
    env   = "Dev"
    owner = "Abdiel"
  }
}

resource "aws_vpc" "vpc_abdiel_ohio" {
  cidr_block = var.ohio_cidr
  tags = {
    Name  = "vpc_abdiel_ohio"
    env   = "Dev"
    owner = "Abdiel"
  }
  provider = aws.ohio
}

variable "virginia_cidr" {
  default = "10.0.0.0/16"
}

variable "ohio_cidr" {
  default = "10.0.0.0/16"
}