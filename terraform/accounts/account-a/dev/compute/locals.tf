locals {
  vpc_a_services = {
    orders = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "order_service")]
      health    = "/order/health"
    }
    payments = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "payment_service")]
      health    = "/payment/health"
    }
    deliveries = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "delivery_service")]
      health    = "/delivery/health"
    }
    machines = {
        instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "machine_service")]
        health    = "/machine/health"
    }
  }
vpc_b_services = {
    auth = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "auth_service")]
      health    = "/auth/health"
    }
    warehouse = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "warehouse_service")]
      health    = "/warehouse/health"
    }
    logger = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "logger_service")]
      health    = "/logs/private/health"
    }
  }
}
