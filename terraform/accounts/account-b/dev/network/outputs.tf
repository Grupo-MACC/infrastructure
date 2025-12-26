output "bastion_eip_id" {
  value = module.eip_bastion.bastion_eip_id
}

output "bastion_eip_allocation_id" {
  value = module.eip_bastion.bastion_eip_allocation_id
}

output "bastion_eip_public_ip" {
  value = module.eip_bastion.bastion_eip_public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_ids  # now a list
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_ids  # now a list
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}