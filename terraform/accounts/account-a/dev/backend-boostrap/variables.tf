variable "environment" {
    type        = string
    default     = "dev"
}

variable "bucket_name" {
    description = "The name of the S3 bucket for backend module"
    type        = string
    default     = "tf-states-macc"
}

variable "allowed_account_arn" {
    description = "The ARN of the allowed account for backend module"
    type        = string
    default     = "arn:aws:iam::901752335700:root"
}