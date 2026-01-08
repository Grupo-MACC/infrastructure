############################
# API
############################
resource "aws_apigatewayv2_api" "this" {
  name          = var.api.name
  protocol_type = var.api.protocol_type
  tags          = var.api.tags
}

############################
# VPC LINKS
############################
resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = var.vpc_links

  name               = each.value.name
  subnet_ids         = each.value.subnet_ids
  security_group_ids = each.value.security_group_ids
  tags               = each.value.tags
}

############################
# ========================
# INTEGRACIONES INTERNAS
# (VPC LINK + ALB LISTENER)
# ========================
############################
resource "aws_apigatewayv2_integration" "internal" {
  for_each = {
    for k, v in var.services : k => v
    if v.vpc_link_id != null
  }

  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  integration_uri = each.value.listener_arn

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.this[each.value.vpc_link_id].id

  payload_format_version = "1.0"
}

############################
# ========================
# INTEGRACIONES EXTERNAS
# (DNS público)
# ========================
############################
resource "aws_apigatewayv2_integration" "external" {
  for_each = {
    for k, v in var.services : k => v
    if v.vpc_link_id == null
  }

  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"

  # ✅ incluir el base_path
  integration_uri = "http://${each.value.nlb_dns}/${each.value.base_path}"

  payload_format_version = "1.0"
}

############################
# ========================
# RUTAS INTERNAS
# ========================
############################
resource "aws_apigatewayv2_route" "internal_base" {
  for_each = aws_apigatewayv2_integration.internal

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /${var.services[each.key].base_path}"
  target    = "integrations/${each.value.id}"
}

resource "aws_apigatewayv2_route" "internal_proxy" {
  for_each = aws_apigatewayv2_integration.internal

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /${var.services[each.key].base_path}/{proxy+}"
  target    = "integrations/${each.value.id}"
}

############################
# ========================
# RUTAS EXTERNAS
# ========================
############################
resource "aws_apigatewayv2_route" "external_base" {
  for_each = aws_apigatewayv2_integration.external

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /${var.services[each.key].base_path}"
  target    = "integrations/${each.value.id}"
}

resource "aws_apigatewayv2_route" "external_proxy" {
  for_each = aws_apigatewayv2_integration.external

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /${var.services[each.key].base_path}/{proxy+}"
  target    = "integrations/${each.value.id}"
}

############################
# STAGE
############################
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  tags = var.stage.tags
}
