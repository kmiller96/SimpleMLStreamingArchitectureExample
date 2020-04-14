## Inference Lambda ##
resource "aws_iam_policy" "inference" {
  name = "${var.resource_prefix}-inference-lambda-policy"
  policy = templatefile(
    "${path.module}/iam_policies/inference.json",
    {
      read_queue_arn  = module.reader_queue.arn,
      write_queue_arn = module.writer_queue.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "inference" {
  role       = module.inference_lambda.lambda_role_name
  policy_arn = aws_iam_policy.inference.arn
}


## Reader Lambda ##
resource "aws_iam_policy" "reader" {
  name = "${var.resource_prefix}-reader-lambda-policy"
  policy = templatefile(
    "${path.module}/iam_policies/reader.json",
    {
      read_queue_arn      = module.reader_queue.arn,
      dynamodb_table_arn  = module.database.arn,
      dynamodb_stream_arn = module.database.stream_arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "reader" {
  role       = module.reader_lambda.lambda_role_name
  policy_arn = aws_iam_policy.reader.arn
}


## Writer Lambda ##
resource "aws_iam_policy" "writer" {
  name = "${var.resource_prefix}-writer-lambda-policy"
  policy = templatefile(
    "${path.module}/iam_policies/writer.json",
    {
      write_queue_arn = module.writer_queue.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "writer" {
  role       = module.writer_lambda.lambda_role_name
  policy_arn = aws_iam_policy.writer.arn
}
