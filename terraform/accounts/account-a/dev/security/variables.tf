variable "environment" {
    type        = string
    default     = "dev"
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block allowed to access SSH"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "internal_cidr" {
    description = "The CIDR block for internal VPC communication"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.11.0/24"]
}