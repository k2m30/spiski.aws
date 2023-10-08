resource "aws_lambda_function" "spiski_lambda" {
  function_name = "spiski"
  role          = aws_iam_role.spiski_role.arn

  runtime          = "python3.11"
  filename         = "${path.module}/delivery/lambda_spiski_payload.zip"
  source_code_hash = data.archive_file.lambda_spiski_payload.output_base64sha256
  handler          = "spiski.lambda_handler"
  timeout          = 90
  memory_size      = 512

  environment {
    variables = {
#      BUCKET_NAME   = aws_s3_bucket.spiski_bucket.bucket
#      JSON_FILE_KEY = "db.json"
    }
  }
}

resource "null_resource" "shell" {
  provisioner "local-exec" {
    command = "${path.module}/lambda_spiski/deps.sh"
  }
}

data "archive_file" "lambda_spiski_payload" {
  depends_on = [null_resource.shell]
  type        = "zip"
  source_dir  = "${path.module}/delivery/lambda_spiski"
  output_path = "${path.module}/delivery/lambda_spiski_payload.zip"
}
