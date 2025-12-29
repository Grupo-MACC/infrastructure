data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-2"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-2"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "bastion" {
    source = "../../../../modules/compute/bastion"
    subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id[0]
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.ssh_key_name
    bastion_sg_id = data.terraform_remote_state.security.outputs.bastion_sg_id

    eip_allocation_id = data.terraform_remote_state.network.outputs.bastion_eip_allocation_id
}

module "rds_mysql" {
  source = "../../../../modules/compute/rds"  # Ruta a tu módulo

  identifier      = "db"
  engine          = "mysql"
  engine_version  = "8.0"
  instance_class  = "db.t3.micro"
  
  allocated_storage = 20
  storage_encrypted = true
  
  database_name   = "app"
  master_username = "admin"
  master_password = "maccadmin"  # Mejor usar AWS Secrets Manager

  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids          = data.terraform_remote_state.network.outputs.private_subnet_id  # Subnets privadas
  sg_id               = data.terraform_remote_state.security.outputs.rds_sg_id
  publicly_accessible = false
  
  skip_final_snapshot = true  # false en producción
}

module "microservices" {
    source = "../../../../modules/compute/ec2"

    ami = var.ami
    key_name = var.ssh_key_name
    sg_id = data.terraform_remote_state.security.outputs.microservices_sg_id
    
    instances = { # 10.1.11.10 -> 10.1.11.250

        consul_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.40"
        }
        rabbitmq_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.30"
        }
        order_service = {
            instance_type = "t3.medium"
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.11"
        }
        /*
        auth_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.10"
        }
        machine_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.12"
        }
        payment_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.13"
        }
        delivery_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.14"
        }
        logs_inf_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.1.12.50"
        }*/
    }
}