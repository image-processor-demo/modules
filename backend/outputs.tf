output "api_gateway_domain_name" {
  value = "${aws_api_gateway_rest_api.api_gateway.id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "api_gateway_stage_name" {
  value = aws_api_gateway_stage.stage.stage_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.image_processor-function.arn
}
