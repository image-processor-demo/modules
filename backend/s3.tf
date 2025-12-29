resource "aws_s3_bucket" "artifacts-bucket" {
  bucket = "image-app-artifacts-bucket-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "artifacts_bucket_public_access" {
  bucket                  = aws_s3_bucket.artifacts-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
