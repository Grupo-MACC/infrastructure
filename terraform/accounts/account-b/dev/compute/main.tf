data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-2"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-2"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

module "bastion" {
    source = "../../../../modules/compute/bastion"
    subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.ssh_key_name
    bastion_sg_id = data.terraform_remote_state.security.outputs.bastion_sg_id

    eip_allocation_id = data.terraform_remote_state.network.outputs.bastion_eip_allocation_id
}

/*module "microservices" {
    source = "../../../../modules/compute/ec2"

    ami = var.ami
    key_name = var.ssh_key_name
    sg_id = data.terraform_remote_state.security.outputs.microservices_sg_id
    
    instances = { # 10.0.11.10 -> 10.0.11.250
        auth_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.10"
        }
        order_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.11"
        }
        machine_service = {
            instance_type = "var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.12"
        }
        payment_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.13"
        }
        delivery_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.14"
        }
        rabbitmq_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.30"
        }
        consul_service = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id
            public_ip     = false
            private_ip    = "10.0.11.40"
        }
    }
}*/