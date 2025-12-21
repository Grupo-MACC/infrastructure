variable "private_route_table_id" {
  description = "ID of the local VPC's private route table"
  type        = string
}

variable "public_route_table_id" {
  description = "ID of the local VPC's public route table"
  type        = string
}

variable "peer_vpc_cidr_blocks" {
  description = "List of CIDR blocks for the peer VPC"
  type        = list(string)
}

variable "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the local VPC's private subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the local VPC's public subnet"
  type        = string
}