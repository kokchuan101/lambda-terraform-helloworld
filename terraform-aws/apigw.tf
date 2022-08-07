resource "aws_api_gateway_rest_api" "hello-world-terraform-aws" {
  name = "hello-world-terraform-aws"
}

resource "aws_api_gateway_resource" "hello_world_api" {
  rest_api_id = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  parent_id   = aws_api_gateway_rest_api.hello-world-terraform-aws.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_resource" "bye_world_api" {
  rest_api_id = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  parent_id   = aws_api_gateway_rest_api.hello-world-terraform-aws.root_resource_id
  path_part   = "bye"
}

resource "aws_api_gateway_method" "hello_world_get" {
  rest_api_id   = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  resource_id   = aws_api_gateway_resource.hello_world_api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "bye_world_get" {
  rest_api_id   = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  resource_id   = aws_api_gateway_resource.bye_world_api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_world_get" {
  depends_on = [
    aws_lambda_function.hello_world
  ]
  rest_api_id = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  resource_id = aws_api_gateway_method.hello_world_get.resource_id
  http_method = aws_api_gateway_method.hello_world_get.http_method

  integration_http_method = "POST" # https://github.com/hashicorp/terraform/issues/9271 Lambda requires POST as the integration type
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world.invoke_arn
}

resource "aws_api_gateway_integration" "bye_world_get" {
  depends_on = [
    aws_lambda_function.bye_world
  ]
  rest_api_id = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  resource_id = aws_api_gateway_method.bye_world_get.resource_id
  http_method = aws_api_gateway_method.bye_world_get.http_method

  integration_http_method = "POST" # https://github.com/hashicorp/terraform/issues/9271 Lambda requires POST as the integration type
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bye_world.invoke_arn
}

resource "aws_api_gateway_deployment" "hello-world-terraform-aws" {
  depends_on = [
    aws_api_gateway_integration.hello_world_get
  ]
  rest_api_id = aws_api_gateway_rest_api.hello-world-terraform-aws.id
}

resource "aws_api_gateway_stage" "prod_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.hello-world-terraform-aws.id
  deployment_id = aws_api_gateway_deployment.hello-world-terraform-aws.id
}
