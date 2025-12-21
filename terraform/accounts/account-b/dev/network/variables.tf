variable "environment" {
    type        = string
    default     = "dev"
}

variable "region" {
  description = "The region for the AWS resources"
  type = string
  default = "us-east-1"
}

variable "az" {
    description = "The availability zone for the VPC"
    type        = string
    default     = "us-east-1a"
}

variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    default     = "dev-account-b"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.1.0.0/16"
}

variable "vpc_public_subnet_cidr" {
  description = "The CIDR block for the VPC public subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "vpc_private_subnet_cidr" {
  description = "The CIDR block for the VPC private subnet"
  type        = string
  default     = "10.1.11.0/24"
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  type        = bool
  default = true  
}