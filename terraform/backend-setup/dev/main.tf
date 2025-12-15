provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "tf-states-macc"
  force_destroy = true

  tags = {
    Name        = "tf-states-macc"
    Environment = "dev"
  }
}