data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2"
    key    = "core-network/dev/terraform.tfstate"
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

/*data "terraform_remote_state" "compute_peer" {
  backend = "s3"
  config = {
    bucket = "tf-states-macc-grupo2-aimar"
    key    = "compute/dev/terraform.tfstate"
    region = "us-east-1"
  }
}*/

module "bastion" {
  source        = "../../../../modules/compute/bastion"
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnet_id[0]
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  bastion_sg_id = data.terraform_remote_state.security.outputs.bastion_sg_id

  eip_allocation_id = data.terraform_remote_state.network.outputs.bastion_eip_allocation_id
}

module "microservices" {
  source = "../../../../modules/compute/ec2"

  ami      = var.ami
  key_name = var.ssh_key_name
  sg_id    = data.terraform_remote_state.security.outputs.microservices_sg_id
  iam_instance_profile = "LabInstanceProfile"

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


module "target_groups_internal" {
  source = "../../../../modules/target-group"

  for_each = local.vpc_a_services

  name        = "${each.key}-tg-dev"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  port        = 5000
  protocol    = "HTTPS"
  target_type = "ip"

  health_check_path     = each.value.health
  health_check_protocol = "HTTPS"
  health_check_port     = "5000"
  health_check_matcher  = "200"

  targets = {
    for k in each.value.instances :
    k => {
      id       = module.microservices.instances_info[k].private_ip
      port     = 5000
      external = false
    }
  }
}

/*module "target_groups_external" {
  source = "../../../../modules/target-group"

  for_each = local.vpc_b_services

  name        = "${each.key}s-tg-dev"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"

  health_check_path = each.value.health

  targets = {
    "${each.value.instances}" = {
      id       = each.value.instances
      port     = 5000
      external = true
    }
  }
}*/