resource "aws_apigatewayv2_api" "this" {
  name          = var.api.name
  protocol_type = var.api.protocol_type
  tags          = var.api.tags
}

resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = var.vpc_links

  name               = each.value.name
  subnet_ids         = each.value.subnet_ids
  security_group_ids = each.value.security_group_ids
  tags               = each.value.tags
}

# Integraciones con VPC Link
resource "aws_apigatewayv2_integration" "this" {
  for_each = var.services

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"

  # Diferenciamos servicios con VPC_LINK vs externos
  integration_uri        = each.value.vpc_link_id != null ? each.value.listener_arn : "http://${each.value.nlb_dns}"

  connection_type        = each.value.vpc_link_id != null ? "VPC_LINK" : "INTERNET"
  connection_id          = each.value.vpc_link_id != null ? aws_apigatewayv2_vpc_link.this[each.value.vpc_link_id].id : null
  payload_format_version = "1.0"
}

# Integraciones externas (sin VPC Link)
resource "aws_apigatewayv2_integration" "external" {
  for_each = {
    for k, v in var.services : k => v
    if v.vpc_link_id == null
  }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${each.value.nlb_dns}"  # apunta al NLB público
  payload_format_version = "1.0"
}

# Rutas
resource "aws_apigatewayv2_route" "this" {
  for_each = {
    for k, v in var.services : k => v
  }

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /${each.value.base_path}"
  target = each.value.vpc_link_id != null ? "integrations/${aws_apigatewayv2_integration.this[each.key].id}" : "integrations/${aws_apigatewayv2_integration.external[each.key].id}"


}


resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Environment = "dev"
  }
}

