resource "aws_lambda_function" "image-processor-function" {
  function_name = "image-processor-function-${var.environment}"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.handler.handler"
  runtime       = "python3.10"
  memory_size   = 512
  timeout       = 30

  # Reference artifact from S3 (uploaded by app CI/CD)
  s3_bucket = var.artifacts_bucket_name
  s3_key    = "lambda/${var.artifact_key}"

  environment {
    variables = {
      ENV               = var.environment
      API_SHARED_SECRET = var.api_shared_secret
    }
  }
}
