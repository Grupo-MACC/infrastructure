output "tg_arn_map" {
  value = { for k, m in module.target_groups : k => m.tg_arn }
}