resource "aws_cloudfront_distribution" "frontend_distribution" {
  # --- S3 origin for frontend ---
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = "S3-frontend-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
    }
  }

  # --- API Gateway origin for backend ---
  origin {
    domain_name = module.backend.api_gateway_domain_name
    origin_id   = "api-origin"

    custom_header {
      name  = "X-Origin-Verify"
      value = var.api_shared_secret
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
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-origin"

    forwarded_values {
      query_string = true
      headers      = ["*"] # forward headers so API Gateway sees them
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
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
