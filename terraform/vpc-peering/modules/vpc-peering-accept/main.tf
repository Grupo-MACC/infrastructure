resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = var.vpc_peering_connection_id
  auto_accept               = var.auto_accept
}