variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource names and tags."
  type        = string
  default     = "multi-cloud-cicd"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "app_port" {
  description = "Application port allowed by the application security group."
  type        = number
  default     = 5000
}

variable "app_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the application security group."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "flow_log_retention_days" {
  description = "CloudWatch retention period for VPC Flow Logs."
  type        = number
  default     = 30
}
