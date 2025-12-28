variable "name" {
  type = string
}

variable "internal" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "listeners" {
  description = "Listeners del ALB"
  type = map(object({
    port     = number
    protocol = string
  }))
}
