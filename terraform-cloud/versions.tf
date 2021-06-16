terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "netology-terraform-hw7"
    key    = "state"
    region = "eu-west-1"
  }
}