data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-aimar"
    key    = "core-network/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "tf-states-macc-aimar"
    key    = "security/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
# Ejemplo de user data para iniciar docker-compose
locals {
  auth_service_user_data = <<-EOF
    #!/bin/bash
    cd /home/ubuntu/app
    docker-compose up -d
    sudo chmod +x /home/ubuntu/app/service_register.sh
    /home/ubuntu/app/service_register.sh
  EOF
}

module "order_service_asg" {
  source = "../../../../modules/ascaling-group"  # Ajusta la ruta según tu estructura

  service_name     = "order${var.service_name}"
  ami              = var.order_ami_final
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

  user_data        = local.auth_service_user_data
}