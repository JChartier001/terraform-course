terraform {
  required_version = "~>1.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      //must match or allow the version of the provider in the module
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}