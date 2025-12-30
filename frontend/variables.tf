variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "api_shared_secret" {
  description = "Shared secret used to verify API origin"
  type        = string
  sensitive   = true
}
