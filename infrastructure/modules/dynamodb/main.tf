resource "aws_dynamodb_table" "this" {
  name = "${var.resource_prefix}-${var.name}"

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