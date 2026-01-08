output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_arn" {
  description = "ARN del Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "ID del Launch Template"
  value       = aws_launch_template.this.id
}

output "launch_template_latest_version" {
  description = "Última versión del Launch Template"
  value       = aws_launch_template.this.latest_version
}