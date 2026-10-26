terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}
