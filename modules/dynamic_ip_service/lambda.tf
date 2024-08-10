resource "aws_iam_role" "lambda_role" {
  name               = "test_lambda_function_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "aws_iam_lambda_policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_python_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

data "archive_file" "zip_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/src/"
  output_path = "${path.module}/python/build/hello-python.zip"
}

resource "aws_lambda_function" "hello_python_lambda" {
  filename         = "${path.module}/python/build/hello-python.zip"
  function_name    = "Terraform_Test_Lambda_Function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.10"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_role]
  source_code_hash = data.archive_file.zip_python_code.output_base64sha256
  environment {
    variables = {
      BUCKET = "com.wgolden.dynamic-ip-cache",
      BUCKET_KEY = "ipaddress.cache"
    }
  }
}

