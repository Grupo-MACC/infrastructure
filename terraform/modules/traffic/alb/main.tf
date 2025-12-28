resource "aws_lb" "this" {
    name = var.name
    internal = var.internal
    load_balancer_type = "application"
    subnets = var.subnets
    security_groups = var.security_groups
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port = each.value.port
  protocol = each.value.protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code = "404"
      content_type = "text/plain"
    }
  }
}