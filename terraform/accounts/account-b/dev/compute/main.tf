data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-b"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-b"
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

module "microservices" {
    source = "../../../../modules/compute/ec2"

    ami = var.ami
    key_name = var.ssh_key_name
    sg_id = data.terraform_remote_state.security.outputs.microservices_sg_id
    iam_instance_profile = "LabInstanceProfile"
    
    instances = { # 10.1.11.10 -> 10.1.11.250
        auth_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.10"
        }
        consul_service = {
            instance_type = var.instance_type_big
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
        rabbitmq_service2 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.1.12.30"
        }
        warehouse_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.11"
        }
        logger_service = {
            instance_type = var.instance_type_big
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.1.11.50"
        }
        logs_inf_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.1.12.50"
        }
        ads_service = {
            instance_type = var.instance_type_big
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.1.12.10"
        }
    }
}