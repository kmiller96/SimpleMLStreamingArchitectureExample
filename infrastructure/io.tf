###############
## Variables ##
###############

variable "resource_prefix" {
  type = string
}

variable "build_directory" {
  type = string
}

variable "source_code_bucket" {
  type = string
}

variable "model_artifacts_bucket" {
  type = string
}

variable "inference_lambda_source_key" {
  type = string
}

variable "writer_lambda_source_key" {
  type = string
}

variable "reader_lambda_source_key" {
  type = string
}

#############
## Outputs ##
#############

output "dynamodb_iot_table_name" {
  value = module.database.iot_table_name
}

output "dynamodb_quality_table_name" {
  value = module.database.quality_table_name
}

output "reader_queue_url" {
  value = module.reader_queue.url
}

output "writer_queue_url" {
  value = module.writer_queue.url
}