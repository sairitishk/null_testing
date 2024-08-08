resource "aws_iam_role" "iam_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "s3_delete_objects_policy" {
  name        = "S3DeleteObjectsPolicy"
  description = "IAM policy to allow listing and deleting objects in an S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.example.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.example.bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.s3_delete_objects_policy.arn
}

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = ""
#   output_path = "lambda_function_payload.zip"
# }

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.module}/code_del.zip"
  function_name = "HelloWorld2"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "code_del.handler"
  # source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
}


resource "null_resource" "invoke_lambda" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      aws lambda invoke \
        --function-name ${aws_lambda_function.test_lambda.function_name} \
        --cli-binary-format raw-in-base64-out \
        --payload '{"key1": "value1"}' \
        response.json
      EOT
 }
}

resource "aws_lambda_permission" "allow_jenkins_invoke" {
  statement_id  = "AllowJenkinsInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "ec2.amazonaws.com"
  source_arn    = "arn:aws:iam::058264252836:role/Admin_Acess_Role_EC2" // Replace with your IAM role ARN
}