terraform {
  backend "s3" {
    bucket         = "tf-states-macc-grupo2-account-a"
    key            = "traffic/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}