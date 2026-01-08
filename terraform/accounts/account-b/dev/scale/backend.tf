terraform {
  backend "s3" {
    bucket         = "tf-states-macc-aimar"
    key            = "scale/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}