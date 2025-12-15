terraform {
  backend "s3" {
    bucket         = "tf-states-macc"
    key            = "compute/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}