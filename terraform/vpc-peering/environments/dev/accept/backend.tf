terraform {
  backend "s3" {
    bucket         = "tf-states-macc-3"
    key            = "vpc-peering-accept/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}