variable "environment" {
    type        = string
    default     = "dev"
}

variable "region" {
  description = "The region for the AWS resources"
  type = string
  default = "us-east-1"
}

variable "az" {
    description = "The availability zone for the VPC"
    type        = string
    default     = "us-east-1a"
}

variable "peer_s3_path" {
  description = "The S3 bucket name for the peer VPC terraform state"
  type = string
  default = "tf-states-macc-2"
}

variable "peer_owner_id" {
    description = "The AWS account ID of the peer VPC owner"
    type        = string
    default     = "901752335700" #aimar
}

variable "peer_vpc_cidr_blocks" {
  description = "The CIDR blocks of the peer VPC"
  type = list(string)
  default = [ "10.1.0.0/16" ]
}