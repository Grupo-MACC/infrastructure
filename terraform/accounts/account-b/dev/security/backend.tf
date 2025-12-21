terraform {
  backend "s3" {
    bucket         = "tf-states-macc-2"
    key            = "security/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}