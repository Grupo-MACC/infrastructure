variable "region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "us-east-1"
}

variable "ami" {
    description = "The AMI ID for the EC2 instances"
    type        = string
    default = "ami-0ecb62995f68bb549"
} 

variable "ssh_key_name" {
    description = "The name of the SSH key pair"
    type        = string
    default     = "vockey"
}

variable "instance_type" {
    description = "The instance type for the bastion host"
    type        = string
    default     = "t3.micro"
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