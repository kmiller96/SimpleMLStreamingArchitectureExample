output "lambda_role_arn" {
  value = aws_iam_role.this.arn
}

output "lambda_role_name" {
  value = aws_iam_role.this.name
}