terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.32.1"
    }
  }

  backend "s3" {
    bucket = "767dev-eks-tfstate-s3"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "767dev-eks_tfstate-db"
  }
}

provider "aws" {
  region = "us-east-1"
}