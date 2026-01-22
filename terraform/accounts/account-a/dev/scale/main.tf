data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-a"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-a"
    key    = "compute/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-grupo2-account-a"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
# Ejemplo de user data para iniciar docker-compose
locals {
  service_user_data = <<-EOF
    #!/bin/bash
    cd /home/ubuntu/app
    docker compose up -d
    sudo chmod +x /home/ubuntu/app/service_register.sh
    /home/ubuntu/app/service_register.sh
  EOF
}
module "payment_service_asg" {
  source = "../../../../modules/ascaling-group"

  service_name     = "payment${var.service_name}"
  ami              = var.payment_ami
  instance_type    = var.instance_type
  key_name         = var.ssh_key_name
  sg_id            = data.terraform_remote_state.security.outputs.microservices_sg_id
  subnet_ids       = [
    data.terraform_remote_state.network.outputs.private_subnet_id[0],
    data.terraform_remote_state.network.outputs.private_subnet_id[1]
  ]

  min_size         = 1
  desired_capacity = 2
  max_size         = 2

  target_group_arns = [
    data.terraform_remote_state.compute.outputs.payments_asg_target_group_arn
  ]

  user_data = local.service_user_data
}

/*
module "payment_service_asg" {
  source = "../../../../modules/ascaling-group"  # Ajusta la ruta según tu estructura

  service_name     = "payment${var.service_name}"
  ami              = var.payment_ami
  instance_type    = var.instance_type_big  # t3.medium
  key_name         = var.ssh_key_name
  sg_id            = data.terraform_remote_state.security.outputs.microservices_sg_id  # Tu security group ID
  subnet_ids       = [
    data.terraform_remote_state.network.outputs.private_subnet_id[0],
    data.terraform_remote_state.network.outputs.private_subnet_id[1]
  ]

  min_size         = 1
  desired_capacity = 2
  max_size         = 2
  target_group_arns = [
    data.terraform_remote_state.compute.outputs.tg_arn_map["payments"]
  ]
  user_data        = local.service_user_data
}
module "order_service_asg" {
  source = "../../../../modules/ascaling-group"  # Ajusta la ruta según tu estructura

  service_name     = "order${var.service_name}"
  ami              = var.order_ami
  instance_type    = var.instance_type_big  # t3.medium
  key_name         = var.ssh_key_name
  sg_id            = data.terraform_remote_state.security.outputs.microservices_sg_id  # Tu security group ID
  subnet_ids       = [
    data.terraform_remote_state.network.outputs.private_subnet_id[0],
    data.terraform_remote_state.network.outputs.private_subnet_id[1]
  ]

  min_size         = 1
  desired_capacity = 2
  max_size         = 2
  target_group_arns = [
    data.terraform_remote_state.compute.outputs.tg_arn_map["orders"]
  ]

  user_data        = local.service_user_data
}
module "machine_service_asg" {
  source = "../../../../modules/ascaling-group"  # Ajusta la ruta según tu estructura

  service_name     = "machine${var.service_name}"
  ami              = var.machine_ami
  instance_type    = var.instance_type_big  # t3.medium
  key_name         = var.ssh_key_name
  sg_id            = data.terraform_remote_state.security.outputs.microservices_sg_id  # Tu security group ID
  subnet_ids       = [
    data.terraform_remote_state.network.outputs.private_subnet_id[0],
    data.terraform_remote_state.network.outputs.private_subnet_id[1]
  ]

  min_size         = 1
  desired_capacity = 2
  max_size         = 2
  target_group_arns = [
    data.terraform_remote_state.compute.outputs.tg_arn_map["machines"]
  ]
  user_data        = local.service_user_data
}
module "delivery_service_asg" {
  source = "../../../../modules/ascaling-group"  # Ajusta la ruta según tu estructura
  service_name     = "delivery${var.service_name}"
  ami              = var.delivery_ami
  instance_type    = var.instance_type_big  # t3.medium
  key_name         = var.ssh_key_name
  sg_id            = data.terraform_remote_state.security.outputs.microservices_sg_id  #
  subnet_ids       = [
      data.terraform_remote_state.network.outputs.private_subnet_id[0],
      data.terraform_remote_state.network.outputs.private_subnet_id[1]
  ]
  min_size         = 1
  desired_capacity = 2
  max_size         = 2
  target_group_arns = [
    data.terraform_remote_state.compute.outputs.tg_arn_map["deliveries"]
  ]
  user_data        = local.service_user_data
}*/