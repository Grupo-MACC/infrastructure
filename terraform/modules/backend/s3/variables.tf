variable "bucket_name" {
  description = "The name of the S3 bucket to store backend data."
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment for which the S3 bucket is being created (e.g., dev, prod)."
  type        = string
}

variable "allowed_account_arn" {
  description = "The ARN of the AWS account that is allowed to access the S3 bucket."
  type        = string
}