variable "vpc_peering_connection_id" {
  description = "ID de la VPC Peering Connection a aceptar"
  type        = string
}

variable "auto_accept" {
  description = "Si se debe aceptar automáticamente la conexión"
  type        = bool
  default     = true
}