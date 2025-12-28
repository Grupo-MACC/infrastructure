module "eip_bastion" {
    source = "../../../../modules/network/eip_bastion"
}

module "vpc" {
  source = "../../../../modules/network/vpc"
  
  name                 = var.environment
  cidr_block           = var.vpc_cidr_block
  public_subnet_cidrs  = var.vpc_public_subnet_cidrs
  private_subnet_cidrs = var.vpc_private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  azs                  = var.azs
}