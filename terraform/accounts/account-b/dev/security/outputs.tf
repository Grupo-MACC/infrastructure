output "bastion_sg_id" {
  value = module.security_groups.bastion_sg_id
}

output "microservices_sg_id" {
  value = module.security_groups.micro_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}