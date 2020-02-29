resource "aws_dynamodb_table" "this" {
    name = "${var.resource_prefix}-${var.name}"

    hash_key = "vatID"
    attribute {
        name = "vatID"
        type = "S"
    }

    write_capacity = 1
    read_capacity = 1
}