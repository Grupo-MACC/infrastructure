variable "subnet_id" {
  description = "The ID of the subnet where the bastion host will be deployed."
  type        = string
}

variable "ami" {
    description = "The AMI ID to use for the bastion host."
    type        = string
}

variable "instance_type" {
    description = "The instance type for the bastion host."
    type        = string
    default     = "t3.micro"
}

variable "key_name" {
    description = "The name of the key pair to use for SSH access to the bastion host."
    type        = string
}

variable "bastion_sg_id" {
    description = "The security group ID to associate with the bastion host."
    type        = string
}

variable "eip_allocation_id" {
  description = "EIP allocation ID para asociar al bastion"
  type        = string
  default     = null
}