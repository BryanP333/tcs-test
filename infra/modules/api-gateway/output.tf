output "api_gateway_execution_arn" {
  description = "API Gateway execution arn"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "api_gateway_id" {
  description = "API Gateway id"
  value       = aws_api_gateway_rest_api.this.id
}