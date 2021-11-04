terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "******"
  secret_key = "******"
  # profile = "you can also have profile name"
}

# further configuration such storing state files to bucket or terraform enterprise can be done.