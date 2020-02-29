resource "aws_sqs_queue" "this" {
    name = var.name
}