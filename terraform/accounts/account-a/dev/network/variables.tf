variable "environment" {
    type        = string
    default     = "dev"
}

variable "region" {
  description = "The region for the AWS resources"
  type = string
  default = "us-east-1"
}

variable "azs" {
  description = "List of availability zones (exactly 2 required)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.azs) == 2
    error_message = "Exactly 2 availability zones must be provided."
  }
}

variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    default     = "dev-account-a"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  type        = bool
  default = true  
}