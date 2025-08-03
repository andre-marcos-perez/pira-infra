resource "aws_batch_compute_environment" "nextflow" {
  compute_environment_name = "${var.nextflow_batch_name}-job-${var.environment}"
  type                     = "MANAGED"
  state                    = "ENABLED"
  service_role             = var.batch_service_role

  compute_resources {
    type               = "FARGATE"
    max_vcpus          = 16
    subnets            = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  tags = {
    "Name"        = "nextflow"
    "Environment" = "${var.environment}"
  }
}

resource "aws_batch_job_queue" "nextflow" {
  name     = "${var.nextflow_batch_name}-queue-${var.environment}"
  state    = "ENABLED"
  priority = 1
  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.nextflow.arn
  }

  tags = {
    "Name"        = "nextflow"
    "Environment" = "${var.environment}"
  }
}
