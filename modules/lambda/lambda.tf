resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = ""
#   output_path = "lambda_function_payload.zip"
# }

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/code.zip"
  function_name = "HelloWorld"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"
  # source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
}
