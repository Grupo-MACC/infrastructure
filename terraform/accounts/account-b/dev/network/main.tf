module "eip_bastion" {
    source = "../../../../modules/network/eip_bastion"
}

module "vpc" {
    source = "../../../../modules/network/vpc"
    name = var.environment
    cidr_block = var.vpc_cidr_block
    public_subnet_cidr = var.vpc_public_subnet_cidr
    private_subnet_cidr = var.vpc_private_subnet_cidr
    enable_nat_gateway = var.enable_nat_gateway
    az = var.az
}