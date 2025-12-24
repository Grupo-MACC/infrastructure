terraform {
  backend "s3" {
    bucket         = "tf-states-macc-grupo2-2"
    key            = "security/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}