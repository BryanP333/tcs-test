resource "aws_api_gateway_rest_api" "this" {
  name = "api-${local.api_access}-${var.pbs_name}"
  endpoint_configuration {
    types = [local.types]
  }
  body = var.body
  tags = merge({ Name = "api-${local.api_access}-${var.pbs_name}" })
}
