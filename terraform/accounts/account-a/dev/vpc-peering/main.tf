data "terraform_remote_state" "vpc_requester" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-a"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc_accepter" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-b"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc_peering_create" {
  source = "../../../../modules/network/vpc-peering-create"

  vpc_id          = data.terraform_remote_state.vpc_requester.outputs.vpc_id
  peer_vpc_id     = data.terraform_remote_state.vpc_accepter.outputs.vpc_id
  peer_owner_id   = var.peer_owner_id
  peer_region     = var.region
}

/*module "vpc_peering_routing" {
  source = "../../../../modules/network/vpc-peering-routing"

  private_route_table_id      = data.terraform_remote_state.vpc_requester.outputs.private_route_table_id
  public_route_table_id       = data.terraform_remote_state.vpc_requester.outputs.public_route_table_id
  peer_vpc_cidr_blocks       = var.peer_vpc_cidr_blocks
  vpc_peering_connection_id   = module.vpc_peering_create.vpc_peering_connection_id
  private_subnet_id          = data.terraform_remote_state.vpc_requester.outputs.private_subnet_id
  public_subnet_id           = data.terraform_remote_state.vpc_requester.outputs.public_subnet_id
}*/

module "vpc_peering_routing" {
  source = "../../../../modules/network/vpc-peering-routing"

  private_route_table_ids = data.terraform_remote_state.vpc_requester.outputs.private_route_table_id
  public_route_table_id   = data.terraform_remote_state.vpc_requester.outputs.public_route_table_id

  peer_vpc_cidr_blocks       = var.peer_vpc_cidr_blocks
  vpc_peering_connection_id   = module.vpc_peering_create.vpc_peering_connection_id
}