module "vpc" {
    source = "../../modules/vpc"
    name = "dev"
    cidr_block = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    private_subnet_cidr = "10.0.11.0/24"
    enable_nat_gateway = true
    az = var.az
}

module "eip_bastion" {
    source = "../../modules/eip_bastion"
}