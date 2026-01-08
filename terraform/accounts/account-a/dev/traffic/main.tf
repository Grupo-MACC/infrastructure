data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network_peer" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

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

data "terraform_remote_state" "traffic" {
  backend = "s3"

    config = {
        bucket = "tf-states-macc-grupo2"
        key    = "traffic/dev/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "compute_peer" {
  backend = "s3"

    config = {
        bucket = "tf-states-macc-grupo2-aimar"
        key    = "compute/dev/terraform.tfstate"
        region = "us-east-1"
    }
}

locals {
    microservices_alb_rules = {
        orders = {
            priority = 10
            paths   = ["/order*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["orders"]
        }
        /*payments = {
            priority = 20
            paths   = ["/payment*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["payments"]
        }
        deliveries = {
            priority = 30
            paths   = ["/delivery*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["deliveries"]
        }
        machines = {
            priority = 40
            paths   = ["/machine*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["machines"]
        }*/
        auths = {
            priority = 50
            paths   = ["/auth*"]
            target_group_arn = data.terraform_remote_state.compute.outputs.tg_arn_map["auth_service"]
        }
    }  
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

module "api_gateway" {
  source = "../../../../modules/traffic/api-gateway"

  api = {
    name          = "internal-api-gateway"
    protocol_type = "HTTP"
    tags = {
      Environment = "dev"
      Project     = "internal-traffic"
    }
  }

  # VPC Links solo para la VPC donde tengas permisos
  vpc_links = {
    microservices_vpc = {
      name               = "microservices-vpc-link"
      subnet_ids         = data.terraform_remote_state.network.outputs.private_subnet_id
      security_group_ids = [data.terraform_remote_state.security.outputs.api_gateway_vpc_link_sg_id]
      tags = {
        Environment = "dev"
        Project     = "internal-traffic"
      }
    }
  }

  services = {
    # Servicios en la misma VPC → usamos VPC_LINK con listener ARN
    orders = {
      base_path     = "order"
      vpc_link_id   = "microservices_vpc"
      nlb_dns    = null
      listener_arn  = module.microservice_internal_alb.listeners["http"]
    }
    payments = {
      base_path     = "payment"
      vpc_link_id   = "microservices_vpc"
      nlb_dns    = null
      listener_arn  = module.microservice_internal_alb.listeners["http"]
    }
    deliveries = {
      base_path     = "delivery"
      vpc_link_id   = "microservices_vpc"
      nlb_dns    = null
      listener_arn  = module.microservice_internal_alb.listeners["http"]
    }
    machines = {
      base_path     = "machine"
      vpc_link_id   = "microservices_vpc"
      nlb_dns    = null
      listener_arn  = module.microservice_internal_alb.listeners["http"]
    }
    auths = {
      base_path   = "auth"
      vpc_link_id = "microservices_vpc"
      nlb_dns     = null
      listener_arn = module.microservice_internal_alb.listeners["http"]
    }
    /*warehouses = {
      base_path   = "warehouse"
      vpc_link_id = "microservices_vpc"
      nlb_dns     = data.terraform_remote_state.traffic_peer.outputs.load_balancer_dns
      listener_arn = module.microservice_internal_alb.listeners["http"]
    }*/
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