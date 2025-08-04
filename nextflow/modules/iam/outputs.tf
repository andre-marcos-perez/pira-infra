output "batch_service_role" {
  value       = aws_iam_role.batch_service_role.arn
  description = "IAM Role ARN for AWS Batch service"
}

output "fargate_execution_role" {
  value       = aws_iam_role.fargate_execution_role.arn
  description = "IAM Role ARN for Fargate task execution"
}
