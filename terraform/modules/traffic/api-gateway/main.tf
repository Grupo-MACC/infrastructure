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

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.services

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = each.value.listener_arn
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this[each.value.vpc_link_id].id
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = local.routes

  api_id    = aws_apigatewayv2_api.this.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.this[each.value.integration].id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  tags = {
    Environment = "dev"
  }
}

