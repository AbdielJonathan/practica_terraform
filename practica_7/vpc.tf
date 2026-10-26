resource "aws_vpc" "vpc_abdiel_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "Vpc Virginia-${local.sufix}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_abdiel_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true # Le asigne direcciones públicas a los recursos dentro de la subnet
  tags = {
    "Name" = "public_subnet-${local.sufix}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_abdiel_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "private_subnet-${local.sufix}"
  }
}

# Gateway a internet para poder acceder a la instancia de ec2
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_abdiel_virginia.id
  tags = {
    Name = "igw vpc virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_abdiel_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public crt-${local.sufix}"
  }

}

resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id

}

resource "aws_security_group" "sg_public_instance" {
  name        = "Puclic INstance SG"
  description = "Allow SSH inbound traffic and ALL egress traficc"
  vpc_id      = aws_vpc.vpc_abdiel_virginia.id

  dynamic "ingress" {
    for_each = var.ingress_ports_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public INstance SG-${local.sufix}"
  }

}

# NOTA: el dynamic remplaza todo lo siguiente:

# ingress {
#     description = "SSH over Internet"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.sg_ingress_cidr]

#   }

# ingress {
#   description = "http over Internet"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   cidr_blocks = [var.sg_ingress_cidr]
# }

# ingress {
#   description = "https over Internet"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   cidr_blocks = [var.sg_ingress_cidr]
# }
