data "archive_file" "hello-world-terraform-aws" {
  type = "zip"

  source_dir  = "../${path.module}/hello-world"
  output_path = "${path.module}/hello-world-terraform-aws.zip"
}

resource "aws_lambda_function" "hello_world" {
  depends_on = [
    aws_iam_role.hello-world-terraform-aws
  ]
  filename      = data.archive_file.hello-world-terraform-aws.output_path
  function_name = "HelloWorld"

  runtime = "nodejs12.x"
  handler = "app.lambdaHandler"

  role = aws_iam_role.hello-world-terraform-aws.arn
}

resource "aws_lambda_function" "bye_world" {
  depends_on = [
    aws_iam_role.hello-world-terraform-aws
  ]
  filename      = data.archive_file.hello-world-terraform-aws.output_path
  function_name = "ByeWorld"

  runtime = "nodejs12.x"
  handler = "bye.lambdaHandler"

  role = aws_iam_role.hello-world-terraform-aws.arn
}
