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

  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key

  environment_variables = {
    OUTPUT_QUEUE_URL = module.writer_queue.url
    MODEL_PATH = "s3://kalemiller-model-artifacts/real-time-wine/model.joblib"
  }
}

module "training_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "training-lambda"
  description     = "Trains a new ML model."
  entrypoint      = "app.training"

  source_bucket = var.source_code_bucket
  source_key    = var.inference_lambda_source_key

  environment_variables = {
    OUTPUT_QUEUE_URL = module.writer_queue.url
    MODEL_PATH = "s3://kalemiller-model-artifacts/real-time-wine/model.joblib"
  }
}

module "reader_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "reader-lambda"
  description     = "Fetches newly changed entries in DynamoDB."

  source_bucket = var.source_code_bucket
  source_key    = var.reader_lambda_source_key

  environment_variables = {
    QUEUE_URL = module.reader_queue.url
  }
}

module "writer_lambda" {
  source = "./modules/lambda"

  resource_prefix = var.resource_prefix
  name            = "writer-lambda"
  description     = "Writes updated quality inferences back into DynamoDB."

  source_bucket = var.source_code_bucket
  source_key    = var.writer_lambda_source_key

  environment_variables = {
    DYNAMODB_TABLE_NAME = module.database.quality_table_name
  }
}

module "database" {
  source = "./modules/dynamodb"

  resource_prefix     = var.resource_prefix
  iot_data_table_name = "vat-iot-data"
  quality_table_name  = "vat-quality-data"
  description         = "Data store for the IoT data. Chosen for quick read/writes."
}

################
## Event Maps ##
################

resource "aws_lambda_event_source_mapping" "dynamodb" {
  depends_on = [module.reader_lambda, module.database]

  event_source_arn  = module.database.iot_stream_arn
  function_name     = module.reader_lambda.function_arn
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "reader_to_inference" {
  depends_on = [module.reader_lambda, module.database]

  event_source_arn  = module.reader_queue.arn
  function_name     = module.inference_lambda.function_arn
}

resource "aws_lambda_event_source_mapping" "inference_to_writer" {
  depends_on = [module.reader_lambda, module.database]

  event_source_arn  = module.writer_queue.arn
  function_name     = module.writer_lambda.function_arn
}