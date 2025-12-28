output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "listeners" {
  value = {
    for k, l in aws_lb_listener.this :
    k => l.arn
  }
}