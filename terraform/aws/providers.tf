terraform {
  required_version = ">= 1.8"

  # Backend placeholder:
  # Configure remote state here when AWS account, S3 bucket, and DynamoDB lock table
  # names are finalized.

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
