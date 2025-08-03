terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "s3" {
  source                      = "./modules/s3"
  environment                 = var.environment
  nextflow_bucket_name_prefix = var.nextflow_bucket_name_prefix
}
