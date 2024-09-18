resource "aws_lambda_function" "auth_function" {
  filename      = "lambda_function_payload.zip"
  function_name = "bryan-${var.pbs_name}-auth"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  runtime = "python3.10"

}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "../../../src/authorizer"
  output_path = "lambda_function_payload.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_bryan-${var.pbs_name}-auth"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

