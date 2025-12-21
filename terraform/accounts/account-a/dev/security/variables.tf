variable "environment" {
    type        = string
    default     = "dev"
}

variable "allowed_ssh_cidr" {
    description = "The CIDR block allowed to access SSH"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}