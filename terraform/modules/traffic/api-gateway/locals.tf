locals {
  routes = merge(
    {
      for name, svc in var.services :
      "${name}_root" => {
        route_key     = "ANY /${svc.base_path}"
        integration   = name
      }
    },
    {
      for name, svc in var.services :
      "${name}_proxy" => {
        route_key     = "ANY /${svc.base_path}/{proxy+}"
        integration   = name
      }
    }
  )
}
