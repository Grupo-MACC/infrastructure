# En cuentas de estudiante AWS, usamos el rol pre-existente "LabRole"
# que ya tiene permisos para SSM, KMS y Secrets Manager

# Data source para obtener el rol existente
data "aws_iam_role" "lab_role" {
  name = var.existing_role_name
}

# Data source para obtener el instance profile existente (si existe)
data "aws_iam_instance_profile" "existing_profile" {
  count = var.use_existing_instance_profile ? 1 : 0
  name  = var.existing_instance_profile_name
}

# Crear instance profile solo si no usamos uno existente
resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.use_existing_instance_profile ? 0 : 1
  name  = "${var.project_name}-${var.environment}-instance-profile"
  role  = data.aws_iam_role.lab_role.name
}