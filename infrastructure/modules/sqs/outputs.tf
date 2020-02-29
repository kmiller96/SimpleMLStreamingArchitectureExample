output "queue_arn" {
  value = aws_sqs_queue.this.arn
}

output "queue_name" {
  value = "${var.resource_prefix}-${var.name}"
}

output "queue_url" {
  value = aws_sqs_queue.this.id
}