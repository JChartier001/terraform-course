terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
provider "aws" {
  region = "us-west-1"
  alias  = "us-west"
}
resource "aws_s3_bucket" "us_west_2_bucket" {
  bucket = "some-random-bucket-name-1234"

}
resource "aws_s3_bucket" "us_west_1_bucket" {
  bucket   = "some-random-bucket-name-123456789"
  provider = aws.us-west

}
