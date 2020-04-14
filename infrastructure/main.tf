#############
## Modules ##
#############

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
  entrypoint      = "app.inference"

  package_path  = "${var.build_directory}/lambda/model.zip"
  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key
}

module "training_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "training-lambda"
  description     = "Trains a new ML model."
  entrypoint      = "app.training"

  package_path  = "${var.build_directory}/lambda/model.zip"
  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key
}

module "reader_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "reader-lambda"
  description     = "Fetches newly changed entries in DynamoDB."

  package_path  = "${var.build_directory}/lambda/reader.zip"
  source_bucket = var.source_code_bucket
  source_key    = var.reader_lambda_source_key
}

module "writer_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "writer-lambda"
  description     = "Writes updated quality inferences back into DynamoDB."

  package_path  = "${var.build_directory}/lambda/writer.zip"
  source_bucket = var.source_code_bucket
  source_key    = var.writer_lambda_source_key
}

module "database" {
  source = "./modules/dynamodb"

  resource_prefix = var.resource_prefix
  name            = "vat-data"
  description     = "Data store for the IoT data. Chosen for quick read/writes."
}

################
## Event Maps ##
################

resource "aws_lambda_event_source_mapping" "dynamodb" {
  depends_on = [module.reader_lambda, module.database]

  event_source_arn  = module.database.stream_arn
  function_name     = module.reader_lambda.function_arn
  starting_position = "LATEST"
}
