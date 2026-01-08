variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "parameters" {
  type = map(object({
    description = string
    value       = string
    secure      = bool
  }))
}
