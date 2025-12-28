resource "aws_lb_listener_rule" "this" {
  for_each = var.rules

  listener_arn = var.listener_arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = each.value.target_group_arn
  }

  condition {
    path_pattern {
      values = each.value.paths
    }
  }
}
