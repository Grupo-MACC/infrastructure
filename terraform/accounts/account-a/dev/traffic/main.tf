data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

/*data "terraform_remote_state" "network_peer" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-2"
    key = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}*/

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "compute/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

/*data "terraform_remote_state" "compute_peer" {
  backend = "s3"

    config = {
        bucket = "tf-states-macc-grupo2-2"
        key    = "compute/dev/terraform.tfstate"
        region = "us-east-1"
    }
}*/

locals {
    microservices_alb_rules = {
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
        machines = {
            priority = 40
            paths   = ["/machine/*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["machines"]
        }
    }  
  /*authentication_alb_rules = {
        auths = {
            priority = 10
            paths   = ["/auth/*"]
            target_group_arn = data.terraform_remote_state.compute_peer.outputs.tg_arn_map["auths"]
        }
        warehouses = {
            priority = 20
            paths   = ["/warehouse/*"]
            target_group_arn = data.terraform_remote_state.compute_peer.outputs.tg_arn_map["warehouses"]
        }
    }*/
}

module "microservice_internal_alb" {
    source = "../../../../modules/traffic/alb"
    name   = "microserviceinternallb"
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

module "microservices_alb_rules" {
    source = "../../../../modules/traffic/alb-rules"
    listener_arn = module.microservice_internal_alb.listeners["http"]
    rules = local.microservices_alb_rules
}

/*module "authentication_internal_alb" {
    source = "../../../../modules/traffic/alb"
    name   = "authinternallb"
    vpc_id = data.terraform_remote_state.network_peer.outputs.vpc_id
    subnets = data.terraform_remote_state.network_peer.outputs.private_subnet_id
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
}*/

module "api_gateway" {
    source = "../../../../modules/traffic/api-gateway"
    api = {
        name = "internal-api-gateway"
        protocol_type = "HTTP"
        tags = {
            Environment = "dev"
            Project     = "internal-traffic"
        }
    }
    vpc_links = {
        microservices_vpc = {
          name = "microservices-vpc-link"
          subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_id
          security_group_ids = [data.terraform_remote_state.security.outputs.api_gateway_vpc_link_sg_id]
          tags = {
              Environment = "dev"
              Project     = "internal-traffic"
          }
        }
        /*authentication_vpc = {
          name = "authentication-vpc-link"
          subnet_ids = data.terraform_remote_state.network_peer.outputs.private_subnet_id
          security_group_ids = [data.terraform_remote_state.security.outputs.api_gateway_vpc_link_sg_id]
          tags = {
              Environment = "dev"
              Project     = "internal-traffic"
          }
        }*/
    }

    services = {
        orders = {
            base_path   = "order"
            vpc_link_id = "microservices_vpc"
            listener_arn = module.microservice_internal_alb.listeners["http"]
        }
        payments = {
            base_path   = "payment"
            vpc_link_id = "microservices_vpc"
            listener_arn = module.microservice_internal_alb.listeners["http"]
        }
        deliveries = {
            base_path   = "delivery"
            vpc_link_id = "microservices_vpc"
            listener_arn = module.microservice_internal_alb.listeners["http"]
        }
        machines = {
            base_path   = "machine"
            vpc_link_id = "microservices_vpc"
            listener_arn = module.microservice_internal_alb.listeners["http"]
        }
    }

    stage = {
        name        = "dev"
        auto_deploy = true
        tags = {
            Environment = "dev"
            Project     = "internal-traffic"
        }
    }
}