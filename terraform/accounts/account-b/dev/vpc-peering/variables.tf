variable "peer_vpc_cidr_blocks" {
  description = "The CIDR blocks of the peer VPC"
  type = list(string)
  default = [ "10.0.0.0/16" ]
}