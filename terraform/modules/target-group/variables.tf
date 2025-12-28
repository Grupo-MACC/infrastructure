variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type    = string
  default = "HTTP"
}

variable "target_type" {
  type    = string
  default = "instance"
}

variable "targets" {
  type = map(object({
    id   = string
    port = number
  }))
}

variable "health_check_path" {
  type    = string
  default = "/health"
}