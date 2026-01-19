locals {
  vpc_a_services = {
    /*orders = {
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
    }*/
    auths = {
      instances = [for k, _ in module.microservices.instances_info : k if startswith(k, "auth_service")]
      health    = "/auth/health"
    }
  }
  vpc_b_services = {
    for service_name, ip in data.terraform_remote_state.compute_peer.outputs.services_private_ips :
    regex("^(.+)_service$", service_name)[0] => {
      instances = ip
      health    = "/${regex("^(.+)_service$", service_name)[0]}/health"
    }
    if (
      startswith(service_name, "auth_") ||
      startswith(service_name, "warehouse_") ||
      startswith(service_name, "logs_")
    )
  }
}
