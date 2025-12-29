variable "api" {
  type = object({
    name          = string
    protocol_type = string
    tags          = map(string)
  })
}

variable "vpc_links" {
  type = map(object({
    name               = string
    subnet_ids         = list(string)
    security_group_ids = list(string)
    tags               = map(string)
  }))
}

variable "services" {
  description = "Servicios expuestos por API Gateway"
  type = map(object({
    base_path   = string   # order, payment, etc
    vpc_link_id = string
    listener_arn = string
  }))
}

variable "stage" {
  type = object({
    name        = string
    auto_deploy = bool
    tags        = map(string)
  })
}
