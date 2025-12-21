variable "vpc_id" {
  description = "ID de la VPC local (requester)"
  type        = string
}

variable "peer_vpc_id" {
  description = "ID de la VPC peer (accepter)"
  type        = string
}

variable "peer_owner_id" {
  description = "Account ID del owner de la VPC peer"
  type        = string
}

variable "peer_region" {
  description = "Región de la VPC peer"
  type        = string
  default     = "us-east-1"
}