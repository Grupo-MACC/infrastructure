# Outputs del módulo de rol

output "instance_profile_name" {
  description = "Nombre del instance profile para usar en EC2"
  value = var.use_existing_instance_profile ? (
    data.aws_iam_instance_profile.existing_profile[0].name
  ) : (
    aws_iam_instance_profile.ec2_profile[0].name
  )
}

output "instance_profile_arn" {
  description = "ARN del instance profile para usar en EC2"
  value = var.use_existing_instance_profile ? (
    data.aws_iam_instance_profile.existing_profile[0].arn
  ) : (
    aws_iam_instance_profile.ec2_profile[0].arn
  )
}

output "role_name" {
  description = "Nombre del rol IAM usado"
  value       = data.aws_iam_role.lab_role.name
}

output "role_arn" {
  description = "ARN del rol IAM usado"
  value       = data.aws_iam_role.lab_role.arn
}
