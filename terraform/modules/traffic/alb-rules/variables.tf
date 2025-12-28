variable "listener_arn" {
  type = string
}

variable "rules" {
  description = "Mapa de reglas del ALB"
  type = map(object({
    priority = number
    paths    = list(string)
    target_group_arn = string
  }))
}