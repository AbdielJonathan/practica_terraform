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

## MODULOS ##

module "mybucket" {
  source      = "./modulos/s3"
  bucket_name = "nombreunicopepelgrillo-1234567" # Por ahora le ponemos un nombre equis pero siempre hay que asegurarse que sea único

}

# Si deseamos hacer un output de un módulo, tenemos que declararlo primero en un output.tf dentro del módulo
output "s3_arn" {
  value = module.mybucket.s3_bucket_arn
}


# ## Módulo para el TFstate ()
# module "terraform_state_backend" {
#   source = "cloudposse/tfstate-backend/aws"
#   # Cloud Posse recommends pinning every module to a specific version
#   version    = "1.9.1"
#   namespace  = "example"
#   stage      = "prod"
#   name       = "terraform-abdiflash-753698"
#   attributes = ["state"]

#   terraform_backend_config_file_path = "."
#   terraform_backend_config_file_name = "backend.tf"
#   force_destroy                      = false
# }
