module "inference_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "inference-lambda"

  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key
}

module "reader_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "reader-lambda"

  source_bucket = var.source_code_bucket
  source_key    = var.reader_lambda_source_key
}

module "writer_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "writer-lambda"

  source_bucket = var.source_code_bucket
  source_key    = var.writer_lambda_source_key
}

module "database" {
  source = "./modules/dynamodb"

  resource_prefix = var.resource_prefix
  name            = "database"
}