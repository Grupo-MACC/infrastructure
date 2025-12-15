data "terraform_remote_state" "peering_create" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"  # Bucket de la otra cuenta (requester)
    key    = "vpc-peering/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

# Llamar al módulo de aceptación
module "vpc_peering_accept" {
  source = "../../../modules/vpc-peering-accept"

  vpc_peering_connection_id = data.terraform_remote_state.peering_create.outputs.peering_connection_id
}