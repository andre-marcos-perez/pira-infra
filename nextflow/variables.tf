variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "terraform_bucket_name" {
  type = string
}

variable "nextflow_bucket_name" {
  type = string
}

variable "nextflow_batch_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}
