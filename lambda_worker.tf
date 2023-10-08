#resource "aws_lambda_function" "worker_lambda" {
#  function_name = "worker"
#  role          = aws_iam_role.spiski_role.arn
#
#  runtime          = "python3.11"
#  filename         = "${path.module}/delivery/lambda_worker_payload.zip"
#  source_code_hash = data.archive_file.lambda_worker_payload.output_base64sha256
#  handler          = "worker.lambda_handler"
#  timeout          = 90
#  memory_size      = 512
#
#  environment {
#    variables = {
#      BUCKET_NAME   = aws_s3_bucket.spiski_bucket.bucket
#      JSON_FILE_KEY = "db.json"
#    }
#  }
#
#}
#
#resource "aws_cloudwatch_event_rule" "every_five_minutes" {
#  name                = "every-five-minutes"
#  description         = "Fires every five minutes"
#  schedule_expression = "rate(1 hour)"
#}
#
#
#resource aws_cloudwatch_event_target "check_db_every_five_minutes" {
#  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
#  target_id = "worker_lambda"
#  arn       = aws_lambda_function.worker_lambda.arn
#}
#
#resource aws_lambda_permission "allow_cloudwatch_to_call_worker" {
#  statement_id  = "AllowExecutionFromCloudWatch"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.worker_lambda.function_name
#  principal     = "events.amazonaws.com"
#  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
#}
#
#data "archive_file" "lambda_worker_payload" {
#  type        = "zip"
#  source_dir  = "${path.module}/lambda_worker"
#  output_path = "${path.module}/delivery/lambda_worker_payload.zip"
#}
