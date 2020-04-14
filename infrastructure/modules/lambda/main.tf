resource "aws_iam_role" "this" {
  name               = "${var.resource_prefix}-${var.name}-role"
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}


resource "aws_s3_bucket_object" "package" {
  bucket = var.source_bucket
  key    = var.source_key
  source = var.package_path
  etag   = filemd5(var.package_path)
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
  source_code_hash = aws_s3_bucket_object.package.etag
}