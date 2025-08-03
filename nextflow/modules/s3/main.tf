resource "aws_s3_bucket" "nextflow" {
  bucket        = "${var.nextflow_bucket_name_prefix}-${var.environment}"

  tags = {
    "Name"        = "nextflow"
    "Environment" = "${var.environment}"
  }
}
