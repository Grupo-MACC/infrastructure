output "tg_arn_map" {
  value = merge(
    { for k, m in module.target_groups_internal : k => m.tg_arn },
    { for k, m in module.target_groups_external : k => m.tg_arn }
  )
}
