terraform {
  backend "s3" {
    bucket         = "tf-states-macc"
    key            = "vpc-peering/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}