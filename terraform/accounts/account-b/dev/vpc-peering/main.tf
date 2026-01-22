data "terraform_remote_state" "vpc_requester" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "vpc-peering/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-grupo2-aimar"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc_peering_accept" {
  source = "../../../../modules/network/vpc-peering-accept"

  vpc_peering_connection_id = data.terraform_remote_state.vpc_requester.outputs.vpc_peering_connection_id
}

/*module "vpc_peering_routing" {
    source = "../../../../modules/network/vpc-peering-routing"

    private_route_table_id = data.terraform_remote_state.network.outputs.private_route_table_id
    public_route_table_id  = data.terraform_remote_state.network.outputs.public_route_table_id
    peer_vpc_cidr_blocks = var.peer_vpc_cidr_blocks
    vpc_peering_connection_id = data.terraform_remote_state.vpc_requester.outputs.vpc_peering_connection_id
    private_subnet_id = data.terraform_remote_state.network.outputs.private_subnet_id
    public_subnet_id  = data.terraform_remote_state.network.outputs.public_subnet_id
}*/

module "vpc_peering_routing" {
  source = "../../../../modules/network/vpc-peering-routing"

  private_route_table_ids = data.terraform_remote_state.network.outputs.private_route_table_id
  public_route_table_id  = data.terraform_remote_state.network.outputs.public_route_table_id

  peer_vpc_cidr_blocks = var.peer_vpc_cidr_blocks
  vpc_peering_connection_id = data.terraform_remote_state.vpc_requester.outputs.vpc_peering_connection_id
}