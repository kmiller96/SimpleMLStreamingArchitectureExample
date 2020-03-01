output "arn" {
  value = aws_sqs_queue.this.arn
}

output "name" {
  value = "${var.resource_prefix}-${var.name}"
}

output "url" {
  value = aws_sqs_queue.this.id
}