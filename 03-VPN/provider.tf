terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.38.0"
    }
  }
  
  backend "s3" {
    bucket = "pesi-terraform-state"
    key    = "roboshop_VPN.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}