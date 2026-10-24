resource "aws_vpc" "vpc_abdiel_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "Vpc Virginia"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_abdiel_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true # Le asigne direcciones públicas a los recursos dentro de la subnet
  tags = {
    "Name" = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_abdiel_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "private_subnet"
  }
}

# Gateway a internet para poder acceder a la instancia de ec2
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_abdiel_virginia.id
  tags = {
    Name = "igw vpc virginia"
  }
}

# Public Custom Route Table
resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_abdiel_virginia.id

  route {
    cidr_block = "0.0.0.0/0" # Para que los recursos en la vpc puedan salir a internet hay que colocar la default route
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public crt"
  }

}

# Asociación de la route table (es algo que aws necesita para usar la Route Tbale de arriba)
resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id

}

# Security Group. En AWS definen los ingress y egress
resource "aws_security_group" "sg_public_instance" {
  name        = "Puclic INstance SG"
  description = "Allow SSH inbound traffic and ALL egress traficc"
  vpc_id      = aws_vpc.vpc_abdiel_virginia.id

  # Definimos que solo se acceda desde internet de esta forma
  ingress {
    description = "SSH over Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_ingress_cidr] # Para más seguridad podríamos asignar una IP pública específica, por ahora lo dejamos en todos (0.0.0.0/0)
    # ipv6_cidr_blocks = ["::/0"] # Como yo no uso ipv6 la comento

  }

  # Definimos que salga a internet solo de esta forma (todo en este caso)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Public INstance SG"
  }

}
