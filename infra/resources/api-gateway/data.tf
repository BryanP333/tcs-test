data "aws_ssm_parameter" "microservice" {
  name = "/${var.pbs_name}/alb/url"
}

data "aws_lambda_function" "auth" {
  function_name = "bryan-${var.pbs_name}-auth"
}
