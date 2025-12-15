terraform {
  backend "s3" {
    bucket         = "tf-states-macc-3"
    key            = "core-network/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}