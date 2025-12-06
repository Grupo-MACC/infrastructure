variable "region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "us-east-1"
}

variable "ami" {
    description = "The AMI ID for the EC2 instances"
    type        = string
} 

variable "ssh_key_name" {
    description = "The name of the SSH key pair"
    type        = string
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block allowed to access via SSH"
    type        = string
}

variable "instance_type" {
    description = "The instance type for the bastion host"
    type        = string
    default     = "t3.micro"
}