data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "security_groups" {
    source = "../../modules/security_groups"
    name = "dev"
    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
    allowed_ssh_cidr = [var.allowed_ssh_cidr]
}