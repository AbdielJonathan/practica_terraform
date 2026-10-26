virginia_cidr = "10.10.0.0/16"
# public_subnet = "10.10.0.0/24"
# private_subnet = "10.10.1.0/24"

subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env"   = "dev"
  "owner" = "Abdiel"
  "Barry" = "Allen"
}


sg_ingress_cidr = "0.0.0.0/0" # all

ec2_specs = {
  "ami"           = "ami-0567589d25e06853e"
  "instance_type" = "t3.micro"
}
