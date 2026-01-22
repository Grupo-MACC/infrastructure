terraform {
  backend "s3" {
    bucket         = "tf-states-grupo2-aimar"
    key            = "security/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}