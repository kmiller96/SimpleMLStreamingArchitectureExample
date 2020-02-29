module "reader_queue" {
  source = "./modules/sqs"

  resource_prefix = var.resource_prefix
  name            = "reader-sqs-queue"
}

module "writer_queue" {
  source = "./modules/sqs"

  resource_prefix = var.resource_prefix
  name            = "writer-sqs-queue"
}

module "inference_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "inference-lambda"
  description     = "Makes inferences on the dataframe passed into the lambda."

  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key
}

module "reader_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "reader-lambda"
  description     = "Fetches newly changed entries in DynamoDB."

  source_bucket = var.source_code_bucket
  source_key    = var.reader_lambda_source_key
}

module "writer_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "writer-lambda"
  description     = "Writes updated quality inferences back into DynamoDB."

  source_bucket = var.source_code_bucket
  source_key    = var.writer_lambda_source_key
}

module "database" {
  source = "./modules/dynamodb"

  resource_prefix = var.resource_prefix
  name            = "vat-data"
  description     = "Data store for the IoT data. Chosen for quick read/writes."
}