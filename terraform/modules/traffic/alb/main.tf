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
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.protocol == "HTTPS" ? coalesce(each.value.ssl_policy, "ELBSecurityPolicy-TLS13-1-2-2021-06") : null
  certificate_arn   = each.value.protocol == "HTTPS" ? each.value.certificate_arn : null

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
    }
  }
}