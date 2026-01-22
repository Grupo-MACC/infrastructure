variable order_ami_final {
  description = "AMI ID for the order service"
  type        = string
  default     = "ami-06d1a5f51f170188f"
}

variable order_ami {
  description = "AMI ID for the order service"
  type        = string
  default     = "ami-012cd67fc2233dcd1"
}

variable machine_ami {
  description = "AMI ID for the machine service"
  type        = string
  default     = "ami-0463a09aa63e76970"
}
variable payment_ami {
  description = "AMI ID for the payment service"
  type        = string
  default     = "ami-0c8e5ed8a1e5d27f5"
}
variable "delivery_ami" {
  description = "AMI ID for the delivery service"
  type        = string
  default     = "ami-053f6a129b0c7ef38"
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
variable "instance_type" {
    description = "The instance type for the bastion host"
    type        = string
    default     = "t3.micro"
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