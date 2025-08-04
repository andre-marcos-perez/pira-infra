data "aws_caller_identity" "current" {}

resource "aws_iam_role" "batch_service_role" {
  name = "${var.nextflow_iam_name}-batch-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "batch.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    "Name" = "nextflow-batch-service-role"
  }
}

resource "aws_iam_role_policy_attachment" "batch_iam_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role" "fargate_execution_role" {
  name = "${var.nextflow_iam_name}-fargate-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    "Name" = "nextflow-fargate-execution-role"
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.nextflow_bucket_name}",
      "arn:aws:s3:::${var.nextflow_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3" {
  name   = "${var.nextflow_iam_name}-s3"
  policy = data.aws_iam_policy_document.s3.json
}

resource "aws_iam_role_policy_attachment" "fargate_iam_policy_s3" {
  role       = aws_iam_role.fargate_execution_role.name
  policy_arn = aws_iam_policy.s3.arn
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/batch/job:*"
    ]
  }

  statement {
    actions = [
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch" {
  name   = "${var.nextflow_iam_name}-cloudwatch"
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_iam_role_policy_attachment" "fargate_iam_policy_cloudwatch" {
  role       = aws_iam_role.fargate_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}
