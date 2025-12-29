resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "image-processor-api-${var.environment}"
  description = "API Gateway for Image Processor Application"

  body = templatefile("${path.module}/openapi.yml", {
    lambda_function_arn = aws_lambda_function.image-processor-function.arn
    aws_region          = var.aws_region
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image-processor-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"

}
