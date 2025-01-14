# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.4"
    }
  }

  backend "s3" {
    bucket         = "terraform-aws-state-bucket" 
    key            = "paul/test/backend-terraform.tfstate"
    region         = "us-east-1"                       
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}