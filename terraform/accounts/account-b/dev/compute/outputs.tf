/*output "db_instance_address" {
  value = module.rds_mysql.db_instance_address
}*/
# output "tg_arn_map" {
#   value = { for k, m in module.target_groups : k => m.tg_arn }
# }

output "instances_info" {
  description = "Information about the created EC2 instances"
  value = module.microservices.instances_info
}