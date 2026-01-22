output "tg_arn_map" {
  value = merge(
    { for k, m in module.target_groups_internal : k => m.tg_arn },
    { for k, m in module.target_groups_external : k => m.tg_arn }
  )
}

output "payments_asg_target_group_arn" {
  description = "ARN del Target Group para el ASG de payments"
  value       = aws_lb_target_group.payments_asg.arn
}

output "payments_asg_target_group_name" {
  description = "Nombre del Target Group para el ASG de payments"
  value       = aws_lb_target_group.payments_asg.name
}