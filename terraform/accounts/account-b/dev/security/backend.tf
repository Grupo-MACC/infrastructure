terraform {
  backend "s3" {
    bucket         = "tf-states-macc-grupo2-account-b"
    key            = "security/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}