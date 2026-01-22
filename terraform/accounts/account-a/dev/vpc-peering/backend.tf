terraform {
  backend "s3" {
    bucket         = "tf-states-macc-grupo2-account-a"
    key            = "vpc-peering/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}