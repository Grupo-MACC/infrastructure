data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"
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
    
    instances = { # 10.0.11.10 -> 10.0.11.250
        order_service_1 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.0.11.11"
        }
        order_service_2 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.0.12.11"
        }
        machine_service_1 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.0.11.12"
        }
        machine_service_2 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.0.12.12"
        }
        payment_service_1 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.0.11.13"
        }
        payment_service_2 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.0.12.13"
        }
        delivery_service_1 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[0]
            public_ip     = false
            private_ip    = "10.0.11.14"
        }
        delivery_service_2 = {
            instance_type = var.instance_type
            subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_id[1]
            public_ip     = false
            private_ip    = "10.0.12.14"
        }
    }
}

module "target_groups" {
  source = "../../../../modules/target-group"

  for_each = local.tg_services

  name        = "${each.key}-tg-dev"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"

  health_check_path = each.value.health

  targets = {
    for k in each.value.instances :
    k => {
      id   = module.microservices.instances_info[k].id
      port = 5000
    }
  }
}