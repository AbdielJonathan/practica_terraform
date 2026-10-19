terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

# Los alias me ayudan a definir mas de un provider de aws, por ejemplo,
# aqui el provider dos es de ohio y eso me prermite en vpc.tf crear 2 VPCs en 2 diferentes regiones

provider "aws" {
  # Configuration options
  region = "us-east-2"
  alias = "ohio"
}
