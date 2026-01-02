/*resource "aws_route" "peering_private_route" {
  route_table_id          = var.private_route_table_id
  count                   = length(var.peer_vpc_cidr_blocks)
  destination_cidr_block  = var.peer_vpc_cidr_blocks[count.index]
  vpc_peering_connection_id = var.vpc_peering_connection_id
}*/

resource "aws_route" "private_peering_route" {
  for_each = {
    for pair in flatten([
      for rt in var.private_route_table_ids : [
        for cidr in var.peer_vpc_cidr_blocks : {
          rt = rt
          cidr = cidr
        }
       ]
     ]) :
    "${pair.rt}-${pair.cidr}" => pair
  }

  route_table_id = each.value.rt
  destination_cidr_block = each.value.cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}
 
/*resource "aws_route_table_association" "peering_private_assoc" {
  subnet_id      = var.private_subnet_id
  route_table_id = var.private_route_table_id
}*/

resource "aws_route" "public_peering_route" {
  for_each = toset(var.peer_vpc_cidr_blocks)

  route_table_id            = var.public_route_table_id
  destination_cidr_block    = each.value
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

/*resource "aws_route_table_association" "peering_public_assoc" {
  subnet_id = var.public_subnet_id
  route_table_id = var.public_route_table_id
}*/