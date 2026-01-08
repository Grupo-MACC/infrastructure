variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod...)"
  type        = string
}

variable "existing_role_name" {
  description = "Nombre del rol IAM existente (ej: LabRole para cuentas de estudiante)"
  type        = string
  default     = "LabRole"
}

variable "use_existing_instance_profile" {
  description = "Si es true, usa un instance profile existente en lugar de crear uno nuevo"
  type        = bool
  default     = true
}

variable "existing_instance_profile_name" {
  description = "Nombre del instance profile existente (ej: LabInstanceProfile)"
  type        = string
  default     = "LabInstanceProfile"
}
