variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}
variable "api_gateway_domain_name" {
  type        = string
  description = "Domain name of the backend API Gateway"
}
variable "api_gateway_stage_name" {
  type        = string
  description = "Stage name of the backend API Gateway"
}
variable "api_shared_secret" {
  description = "Shared secret used to verify API origin"
  type        = string
  sensitive   = true
}
