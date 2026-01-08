resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = var.health_check_path
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = var.targets

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value.id
  port             = each.value.port
  availability_zone = each.value.external ? "all" : null
}