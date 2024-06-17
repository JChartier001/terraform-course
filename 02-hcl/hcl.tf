terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

//actively managed by us
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.my_variable

}

//managed by someone else but use in the project
data "aws_s3_bucket" "my_external_bucket" {
  bucket = "not-managed-by-us"
}

variable "my_variable" {
  type        = string
  description = "This is my variable"
  default="default value"
}

output "bucket_id" {
    value = aws_s3_bucket.my_bucket.id
}


//temp variables
locals {
    my_local_variable = "local value"
}

module "my_module" {
    source = "./my_module"
    my_module_variable = "module value"

}