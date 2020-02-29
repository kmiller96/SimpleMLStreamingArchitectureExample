resource "aws_sqs_queue" "this" {
  name = "${var.resource_prefix}-${var.name}"
}