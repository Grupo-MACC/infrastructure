output "vpc_peering_connection_id" {
  description = "ID de la VPC Peering Connection"
  value       = module.vpc_peering_create.vpc_peering_connection_id
}

output "peering_status" {
  description = "Estado de la conexión de peering"
  value      = module.vpc_peering_create.peering_status
}

output "vpc_id" {
  description = "ID de la VPC local (requester)"
  value       = module.vpc_peering_create.vpc_id
}

output "peer_vpc_id" {
  description = "ID de la VPC peer (accepter)"
  value       = module.vpc_peering_create.peer_vpc_id
}