terraform {
  backend "s3" {
    bucket         = "tf-states-macc"
    key            = "core-network/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}