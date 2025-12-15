module "vpc" {
    source = "../../modules/vpc"
    name = "dev2"
    cidr_block = "10.1.0.0/16"
    public_subnet_cidr = "10.1.1.0/24"
    private_subnet_cidr = "10.1.11.0/24"
    enable_nat_gateway = true
    az = var.az
}

module "eip_bastion" {
    source = "../../modules/eip_bastion"
}