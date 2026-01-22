terraform {
  backend "s3" {
    bucket         = "tf-states-grupo2-aimar"
    key            = "core-network/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}