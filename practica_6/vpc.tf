resource "aws_vpc" "vpc_abdiel_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name  = "vpc_abdiel_virginia"
    env   = "Dev"
    owner = "Abdiel"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_abdiel_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true # Le asigne direcciones públicas a los recursos dentro de la subnet
  tags = {
    Name  = "Public subnet"
    env   = "Dev"
    owner = "Abdiel"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_abdiel_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    Name  = "Private subnet"
    env   = "Dev"
    owner = "Abdiel"
  }
}
