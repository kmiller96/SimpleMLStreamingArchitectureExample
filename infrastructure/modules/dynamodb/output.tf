output "iot_table_arn" {
  value = aws_dynamodb_table.iot.arn
}

output "iot_stream_arn" {
  value = aws_dynamodb_table.iot.stream_arn
}

output "iot_table_name" {
  value = aws_dynamodb_table.iot.id
}

output "quality_table_arn" {
  value = aws_dynamodb_table.quality.arn
}

output "quality_table_name" {
  value = aws_dynamodb_table.quality.id
}