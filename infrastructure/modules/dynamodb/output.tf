output "arn" {
    value = aws_dynamodb_table.this.arn
}

output "table" {
    value = aws_dynamodb_table.this.id
}