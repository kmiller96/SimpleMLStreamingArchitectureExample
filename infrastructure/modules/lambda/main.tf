resource "aws_iam_role" "this" {
  name               = "${var.resource_prefix}-${var.name}-role"
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

resource "aws_lambda_function" "this" {
  function_name = "${var.resource_prefix}-${var.name}"
  description   = var.description
  role          = aws_iam_role.this.arn

  handler     = "app.lambda_handler"
  runtime     = "python3.8"
  memory_size = var.memory_size
  timeout     = var.timeout
  environment {
    variables = var.environment_variables
  }

  s3_bucket = var.source_bucket
  s3_key    = var.source_key
}