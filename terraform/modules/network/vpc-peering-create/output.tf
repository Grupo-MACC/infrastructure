output "vpc_peering_connection_id" {
  description = "ID de la VPC Peering Connection"
  value       = aws_vpc_peering_connection.this.id
}

output "peering_status" {
  description = "Estado de la conexión de peering"
  value       = aws_vpc_peering_connection.this.accept_status
}

output "vpc_id" {
  description = "ID de la VPC local (requester)"
  value       = aws_vpc_peering_connection.this.vpc_id
}

output "peer_vpc_id" {
  description = "ID de la VPC peer (accepter)"
  value       = aws_vpc_peering_connection.this.peer_vpc_id
}