locals {
  tg_services = {
    auths = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "auth_service")]
      health    = "/health"
    }
    warehouses = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "warehouse_service")]
      health    = "/health"
    }
  }
}
