resource "aws_vpc" "vpc_abdiel_virginia" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "vpc_abdiel_virginia"
    env   = "Dev"
    owner = "Abdiel"
  }
}

resource "aws_vpc" "vpc_abdiel_ohio" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "vpc_abdiel_ohio"
    env   = "Dev"
    owner = "Abdiel"
  }
  provider = aws.ohio
}