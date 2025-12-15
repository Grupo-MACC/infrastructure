data "terraform_remote_state" "vpc_requester" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

# Leer el remote state de la otra cuenta (VPC accepter)
data "terraform_remote_state" "vpc_accepter" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-3"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

# Llamar al módulo para crear el peering
module "vpc_peering_create" {
  source = "../../../modules/vpc-peering-create"

  vpc_id          = data.terraform_remote_state.vpc_requester.outputs.vpc_id
  peer_vpc_id     = data.terraform_remote_state.vpc_accepter.outputs.vpc_id
  peer_owner_id   = data.terraform_remote_state.vpc_accepter.outputs.account_id
  peer_region     = "us-east-1"
}