data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key    = "compute/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  authentication_alb_rules = {
        auths = {
            priority = 10
            paths   = ["/auth/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["auths"]
        }
        warehouses = {
            priority = 20
            paths   = ["/warehouse/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["warehouses"]
        }
    }
}

module "authentication_internal_alb" {
    source = "../../../../modules/traffic/alb"
    name   = "authinternallb"
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

module "authentication_alb_rules" {
    source = "../../../../modules/traffic/alb-rules"
    listener_arn = module.authentication_internal_alb.listeners["http"]
    rules = local.authentication_alb_rules
}