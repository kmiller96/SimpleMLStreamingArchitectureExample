resource "aws_lambda_event_source_mapping" "dynamodb" {
  depends_on = [module.reader_lambda, module.database]

  event_source_arn  = module.database.stream_arn
  function_name     = module.reader_lambda.function_arn
  starting_position = "LATEST"
}