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
