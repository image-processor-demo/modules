resource "aws_cloudfront_distribution" "frontend_distribution" {
  # --- S3 origin for frontend ---
  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id                = "S3-frontend-bucket"
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  # --- API Gateway origin for backend ---
  origin {
    domain_name = var.api_gateway_domain_name
    origin_id   = "api-origin"
    origin_path = "/${var.api_gateway_stage_name}"

    custom_header {
      name  = "X-Origin-Verify"
      value = var.api_shared_secret
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for frontend + API"
  default_root_object = "index.html"

  # Default behavior → frontend bucket
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-frontend-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Ordered behavior → API Gateway
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    target_origin_id = "api-origin"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"

    compress = false

    # Use AWS managed policies for binary response handling
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # Managed-AllViewer

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "image-processor"
  }

}

resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "frontend-oac"
  description                       = "OAC for frontend S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Remove the custom policies - we're using AWS managed ones now
# You can delete these two resources:
# - aws_cloudfront_cache_policy.api_no_cache
# - aws_cloudfront_origin_request_policy.api_all
