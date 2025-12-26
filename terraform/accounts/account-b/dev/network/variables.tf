variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "dev-account-a"
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default = "10.1.0.0/16"
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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (2 required)"
  type        = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly 2 public subnet CIDRs must be provided."
  }
  default = [ "10.1.1.0/24", "10.1.2.0/24" ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (2 required)"
  type        = list(string)
  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly 2 private subnet CIDRs must be provided."
  }
  default = [ "10.1.11.0/24", "10.1.12.0/24" ]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.1.0.0/16"
}
variable "vpc_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24"]
}
variable "vpc_private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = ["10.1.11.0/24", "10.1.12.0/24"]
}
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

