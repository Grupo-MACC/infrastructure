locals {
  tg_services = {
    auths = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "auth_service")]
      health    = "/auth/health"
    }
    warehouses = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "warehouse_service")]
      health    = "/warehouse/health"
    }
  }
}
