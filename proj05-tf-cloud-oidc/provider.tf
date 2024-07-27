terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "Farm2Table"

    workspaces {
      name = "terraform-cli"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  sts_region = "us-east-2"
}
