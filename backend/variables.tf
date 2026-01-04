variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "artifact_key" {
  description = "S3 object key for the Lambda artifact"
  type        = string
}


variable "aws_region" {
  description = "The AWS region where the resources will be deployed."
  type        = string
  default     = "eu-west-1"
}

variable "artifacts_bucket_name" {
  description = "S3 bucket where Lambda artifacts are stored"
  type        = string
}

variable "api_shared_secret" {
  description = "Shared secret used to verify API origin"
  type        = string
  sensitive   = true
}
