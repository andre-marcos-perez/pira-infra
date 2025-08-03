resource "aws_s3_bucket" "nextflow" {
  bucket = "${var.nextflow_bucket_name}-${var.environment}"

  tags = {
    "Name"        = "nextflow-bucket"
    "Environment" = "${var.environment}"
  }
}
