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
  default = "ip"
}

variable "targets" {
  type = map(object({
    id   = string
    port = number
    external = optional(bool, false)
  }))
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}