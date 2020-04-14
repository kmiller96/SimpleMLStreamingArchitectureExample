resource "aws_dynamodb_table" "iot" {
  name = "${var.resource_prefix}-${var.iot_data_table_name}"

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  hash_key = "vatID"
  attribute {
    name = "vatID"
    type = "S"
  }

  write_capacity = 1
  read_capacity  = 1
}


resource "aws_dynamodb_table" "quality" {
  name = "${var.resource_prefix}-${var.quality_table_name}"

  hash_key = "vatID"
  attribute {
    name = "vatID"
    type = "S"
  }

  range_key = "timestamp_in_seconds"
  attribute {
    name = "timestamp_in_seconds"
    type = "N"
  }

  write_capacity = 1
  read_capacity  = 1
}