terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "Farm2Table"

    workspaces {
      name = "terraform-course"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  sts_region = "us-east-2"
  #   assume_role {
  #     role_arn 
  #   }
}


//TFC_AWS_RUN_ROLE_ARN
//TFC_AWS_PROVIDER_AUTH
