resource "aws_iam_role" "this" {
  name               = "${var.resource_prefix}-${var.name}-role"
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "service_role" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "aws_s3_bucket_object" "package" {
  bucket = var.source_bucket
  key    = var.source_key
}

resource "aws_lambda_function" "this" {
  function_name = "${var.resource_prefix}-${var.name}"
  description   = var.description
  role          = aws_iam_role.this.arn

  handler     = var.entrypoint
  runtime     = "python3.8"
  memory_size = var.memory_size
  timeout     = var.timeout
  environment {
    variables = var.environment_variables
  }

  s3_bucket        = var.source_bucket
  s3_key           = var.source_key
  source_code_hash = data.aws_s3_bucket_object.package.etag
}