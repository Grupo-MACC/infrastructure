output "load_balancer_dns" {
  value = module.microservice_internal_alb.alb_dns_name
}