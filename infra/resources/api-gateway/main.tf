module "apigateway" {
  source                            = "../../modules/api-gateway/"
  app_api_access                    = var.app_api_access
  pbs_name                          = var.pbs_name
  body = templatefile("api.yaml", {
    load_balancer_url = data.aws_ssm_parameter.microservice.value
    lambda_auth_function_arn = data.aws_lambda_function.auth.invoke_arn
  })
}

resource "aws_lambda_permission" "auth_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = "bryan-${var.pbs_name}-auth"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.apigateway.api_gateway_execution_arn}/authorizers/*"
}

resource "aws_api_gateway_stage" "this" {
  deployment_id        = aws_api_gateway_deployment.this.id
  rest_api_id          = module.apigateway.api_gateway_id
  stage_name           = "DevOps"
  tags                 = { Name = "DevOps" }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = module.apigateway.api_gateway_id
  description = "Deployed at ${timestamp()}"
  variables = {
    deployed_at = timestamp()
  }
  lifecycle {
    create_before_destroy = true
  }
}
