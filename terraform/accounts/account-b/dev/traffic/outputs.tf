output "load_balancer_dns" {
    value = module.authentication_internal_alb.alb_dns_name
}