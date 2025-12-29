variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "filename" {
  description = "The path to the Lambda function deployment package."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the resources will be deployed."
  type        = string
  default     = "eu-west-1"
}
