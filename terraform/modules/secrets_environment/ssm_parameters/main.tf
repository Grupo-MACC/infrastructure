resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name        = "/${var.project_name}/${var.environment}/${each.key}"
  description = each.value.description

  type  = each.value.secure ? "SecureString" : "String"
  value = each.value.value

  key_id   = each.value.secure ? var.kms_key_id : null
  overwrite = true
}