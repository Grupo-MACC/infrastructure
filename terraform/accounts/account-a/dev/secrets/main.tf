module "kms" {
  source = "../../../../modules/secrets_environment/kms"

  project_name = var.project_name
  environment  = var.environment
}

module "ssm" {
  source = "../../../../modules/secrets_environment/ssm_parameters"

  project_name = var.project_name
  environment  = var.environment
  kms_key_id   = module.kms.key_id

  parameters = var.ssm_parameters
}

module "secrets" {
  source = "../../../../modules/secrets_environment/secrets_manager"

  project_name = var.project_name
  environment  = var.environment
  kms_key_arn  = module.kms.key_arn

  secrets = var.secrets_manager_secrets
}


# Usa el LabRole y LabInstanceProfile existentes en cuentas de estudiante AWS
module "iam_role" {
  source = "../../../../modules/secrets_environment/rol"

  project_name                  = var.project_name
  environment                   = var.environment
  # Usar instance profile existente (LabInstanceProfile)
  use_existing_instance_profile = true
  existing_instance_profile_name = "LabInstanceProfile"
  existing_role_name            = "LabRole"
}