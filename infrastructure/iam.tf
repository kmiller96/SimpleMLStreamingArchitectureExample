## Inference Lambda ##
resource "aws_iam_policy" "inference" {
    name = "${var.resource_prefix}-inference-lambda-policy"
    policy = file("${path.module}/iam_policies/inference.json")
}

resource "aws_iam_role_policy_attachment" "inference" {
    role = module.inference.lambda_role_name
    policy_arn = aws_iam_policy.inference.arn
}


## Reader Lambda ##
resource "aws_iam_policy" "reader" {
    name = "${var.resource_prefix}-reader-lambda-policy"
    policy = file("${path.module}/iam_policies/reader.json")
}

resource "aws_iam_role_policy_attachment" "reader" {
    role = module.reader.lambda_role_name
    policy_arn = aws_iam_policy.reader.arn
}


## Writer Lambda ##
resource "aws_iam_policy" "writer" {
    name = "${var.resource_prefix}-writer-lambda-policy"
    policy = file("${path.module}/iam_policies/writer.json")
}

resource "aws_iam_role_policy_attachment" "writer" {
    role = module.writer.lambda_role_name
    policy_arn = aws_iam_policy.writer.arn
}