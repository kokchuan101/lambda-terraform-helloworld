output "base_url" {
  description = "base url"

  value = aws_api_gateway_stage.prod_stage.invoke_url
}
