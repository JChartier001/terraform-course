import {
  to = aws_lambda_function.this
  id = "manually-created-lambda"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.root}/build/index.mjs"
  output_path = "${path.root}/lambda.zip"
}


resource "aws_lambda_function" "this" {
  description   = "A starter AWS Lambda function."
  filename      = "lambda.zip"
  function_name = "manually-created-lambda"
  handler       = "index.handler"

  role    = "arn:aws:iam::891376936920:role/service-role/manually-created-lambda-role-dgk8hzsk"
  runtime = "nodejs18.x"

  source_code_hash = null
  tags = {
    "lambda-console:blueprint" = "hello-world"
  }

  timeout = 3
  ephemeral_storage {
    size = 512
  }
  logging_config {

    log_format = "Text"
    log_group  = "/aws/lambda/manually-created-lambda"

  }

}
