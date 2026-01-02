data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "security_groups" {
    source = "../../../../modules/security/security_groups"
    name = var.environment
    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
    allowed_ssh_cidr = var.allowed_ssh_cidr
    internal_cidr = var.internal_cidr
}