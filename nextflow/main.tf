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
  source               = "./modules/s3"
  environment          = var.environment
  nextflow_bucket_name = var.nextflow_service_name
}

module "vpc" {
  source            = "./modules/vpc"
  availability_zone = var.availability_zone
}

module "iam" {
  source               = "./modules/iam"
  nextflow_iam_name    = var.nextflow_service_name
  nextflow_bucket_name = module.s3.nextflow_bucket_name
}

module "batch" {
  source              = "./modules/batch"
  environment         = var.environment
  nextflow_batch_name = var.nextflow_service_name
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_id   = module.vpc.sg_id
  batch_service_role  = module.iam.batch_service_role
}
