module "vpc" {
    source = "../../modules/vpc"
    name = "dev"
    cidr_block = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    private_subnet_cidr = "10.0.11.0/24"
    enable_nat_gateway = true
}

module "security" {
    source = "../../modules/security"
    name = "dev"
    vpc_id = module.vpc.vpc_id
    allowed_ssh_cidr = [var.allowed_ssh_cidr]
}

module "bastion" {
    source = "../../modules/bastion"
    subnet_id = module.vpc.public_subnet_id
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.ssh_key_name
    bastion_sg_id = module.security.bastion_sg_id
}

module "microservices" {
    source = "../../modules/ec2"

    ami = var.ami
    key_name = var.ssh_key_name
    sg_id = module.security.micro_sg_id

    instances = {
        auth_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }
        /*order_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }
        machine_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }
        payment_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }
        delivery_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }
        rabbitmq_service = {
            instance_type = "t3.micro"
            subnet_id     = module.vpc.private_subnet_id
            public_ip     = false
        }*/
    }
}