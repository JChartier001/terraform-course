import {
  to = aws_iam_role.lambda_execution_role
  id = "manually-created-lambda-role-dgk8hzsk"
}

import {
  to = aws_iam_policy.lambda_execution
  id = "arn:aws:iam::891376936920:policy/service-role/AWSLambdaBasicExecutionRole-d38ea8c0-5690-45cf-b681-554b5e880c5f"
}

data "aws_iam_policy_document" "assume_lambda_execution_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda_execution" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "lambda_execution" {
  name   = "AWSLambdaBasicExecutionRole-d38ea8c0-5690-45cf-b681-554b5e880c5f"
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.lambda_execution.json
}


resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json
  name               = "manually-created-lambda-role-dgk8hzsk"
  path               = "/service-role/"

}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}
