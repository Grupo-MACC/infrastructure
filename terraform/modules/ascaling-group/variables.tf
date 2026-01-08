variable "service_name" {
  description = "Nombre del servicio"
  type        = string
}

variable "ami" {
  description = "AMI ID para las instancias"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "key_name" {
  description = "Nombre del key pair para SSH"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnet IDs para el ASG"
  type        = list(string)
}

variable "min_size" {
  description = "Capacidad mínima del ASG"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Capacidad deseada del ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Capacidad máxima del ASG"
  type        = number
  default     = 2
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}