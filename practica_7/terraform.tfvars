virginia_cidr = "10.10.0.0/16"
# public_subnet = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"         = "dev"
  "owner"       = "Abdiel"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC Version" = "1.17.0"
  "Barry"       = "Allen"
  "project"     = "cerberus"
  "region"      = "virginia"
}


sg_ingress_cidr = "0.0.0.0/0" # all

ec2_specs = {
  "ami"           = "ami-04b938437b69a2c9c"
  "instance_type" = "t3.micro"
}

enable_monitoring = false
