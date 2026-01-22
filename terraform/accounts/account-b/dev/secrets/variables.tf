variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "ssm_parameters" {
  type      = any
}

variable "secrets_manager_secrets" {
  type      = any
}