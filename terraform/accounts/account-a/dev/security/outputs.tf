output "bastion_sg_id" {
  value = module.security_groups.bastion_sg_id
}

output "microservices_sg_id" {
  value = module.security_groups.micro_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "load_balancer_sg_id" {
  value = module.security_groups.load_balancer_sg_id
}

output "api_gateway_vpc_link_sg_id" {
  value = module.security_groups.api_gateway_vpc_link_sg_id
}