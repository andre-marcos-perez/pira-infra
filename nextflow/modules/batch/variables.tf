variable "environment" {
  type = string
}

variable "nextflow_batch_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "batch_service_role" {
  type = string
}
