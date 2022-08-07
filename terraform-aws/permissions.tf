resource "aws_iam_role" "hello-world-terraform-aws" {
  name = "hello-world-terraform-aws"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_lambda_permission" "hello_world_permission" {
  depends_on = [
    aws_lambda_function.hello_world,
    aws_api_gateway_rest_api.hello-world-terraform-aws
  ]
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hello-world-terraform-aws.execution_arn}/*/GET/hello"
}

resource "aws_lambda_permission" "bye_world_permission" {
  depends_on = [
    aws_lambda_function.bye_world,
    aws_api_gateway_rest_api.hello-world-terraform-aws
  ]
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bye_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.hello-world-terraform-aws.execution_arn}/*/GET/bye"
}



# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.hello-world-terraform-aws.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
