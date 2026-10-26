variable "virginia_cidr" {
  description = "CIRD Virginia"
  type        = string
}

# variable "public_subnet" {
#     description = "CIDR public subnet"
#     type = string
# }

# variable "private_subnet" {
#     description = "CIDR private subnet"
#     type = string
# }

variable "subnets" {
  description = "lista de subnets"
  type        = list(string)
}


variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}


variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string

}

variable "ec2_specs" {
  description = "Parámetros de la instancia"
  type        = map(string)

}

variable "enable_monitoring" {
  description = "Habilitar la instancia de monitoreo"
  type        = bool
}
