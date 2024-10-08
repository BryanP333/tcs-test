terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-west-2"
}
