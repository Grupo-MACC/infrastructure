terraform {
  backend "s3" {
    bucket         = "tf-states-macc"
    key            = "security/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}
