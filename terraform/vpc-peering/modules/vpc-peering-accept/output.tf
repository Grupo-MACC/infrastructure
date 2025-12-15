output "peering_connection_id" {
  description = "ID de la conexión de peering"
  value       = aws_vpc_peering_connection_accepter.this.id
}

output "peering_status" {
  description = "Estado de la conexión de peering"
  value       = aws_vpc_peering_connection_accepter.this.accept_status
}

output "vpc_peering_connection_id" {
  description = "ID original de la VPC Peering Connection"
  value       = aws_vpc_peering_connection_accepter.this.vpc_peering_connection_id
}