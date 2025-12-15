output "bastion_eip_allocation_id" {
  value = module.eip_bastion.bastion_eip_allocation_id
}

output "bastion_public_ip" {
  value = module.eip_bastion.bastion_eip_public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}