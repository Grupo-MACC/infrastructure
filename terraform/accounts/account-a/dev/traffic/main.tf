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

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc"
    key    = "compute/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
    alb_rules = {
        orders = {
            priority = 10
            paths   = ["/order/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["orders"]
        }
        payments = {
            priority = 20
            paths   = ["/payment/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["payments"]
        }
        deliveries = {
            priority = 30
            paths   = ["/delivery/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["deliveries"]
        }
        /*machines = {
            priority = 40
            paths   = ["/machine/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["machines"]
        }*/
    }  
}

module "internal_alb" {
    source = "../../../../modules/traffic/alb"
    name   = "internallb"
    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
    subnets = data.terraform_remote_state.network.outputs.private_subnet_id
    security_groups = [data.terraform_remote_state.security.outputs.load_balancer_sg_id]
    listeners = {
        http = {
            port    = 80
            protocol = "HTTP"
        }
    }
}

module "alb_rules" {
    source = "../../../../modules/traffic/alb-rules"
    listener_arn = module.internal_alb.listeners["http"]
    rules = local.alb_rules
}