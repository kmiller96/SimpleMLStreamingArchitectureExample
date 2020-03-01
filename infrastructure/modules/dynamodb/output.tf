output "arn" {
  value = aws_dynamodb_table.this.arn
}

output "stream_arn" {
  value = aws_dynamodb_table.this.stream_arn
}

output "table" {
  value = aws_dynamodb_table.this.id
}