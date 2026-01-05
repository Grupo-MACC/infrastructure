
variable order_ami {
  description = "AMI ID for the order service"
  type        = string
  default     = "ami-0dfb93839fdc220b2"
}
	

variable order_ami_final {
  description = "AMI ID for the order service"
  type        = string
  default     = "ami-06d1a5f51f170188f"
}
variable service_name {
  description = "Name of the service to be deployed"
  type        = string
  default     = "_service_autoscaled"
}
variable "instance_type_big" {
    description = "The instance type for the bastion host"
    type        = string
    default     = "t3.medium"
}

variable "az" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}
variable "ssh_key_name" {
    description = "The name of the SSH key pair"
    type        = string
    default     = "vockey"
}