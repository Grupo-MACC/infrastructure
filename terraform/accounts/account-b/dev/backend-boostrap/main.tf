module "s3_backend" {
    source = "../../../../modules/backend/s3"
    bucket_name = var.bucket_name
    environment = var.environment
    allowed_account_arn = var.allowed_account_arn
}