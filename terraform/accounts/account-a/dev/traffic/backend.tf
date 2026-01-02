terraform {
  backend "s3" {
    bucket         = "tf-states-macc-grupo2"
    key            = "traffic/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}