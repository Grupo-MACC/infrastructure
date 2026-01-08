/*output "api_id" {
  value = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

output "vpc_links" {
  value = {
    for k, v in aws_apigatewayv2_vpc_link.this : k => v.id
  }
}

output "integration_ids" {
  value = {
    for k, v in aws_apigatewayv2_integration.this : k => v.id
  }
}*/