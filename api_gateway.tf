resource "aws_apigatewayv2_api" "main" {
  name          = "main"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.main.id

  name        = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "spiski" {
  api_id = aws_apigatewayv2_api.main.id

  integration_uri    = aws_lambda_function.spiski_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_index" {
  api_id = aws_apigatewayv2_api.main.id

  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.spiski.id}"
}

#resource "aws_apigatewayv2_route" "get_query" {
#  api_id = aws_apigatewayv2_api.main.id
#
#  route_key = "GET /q"
#  target    = "integrations/${aws_apigatewayv2_integration.spiski.id}"
#}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.spiski_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

output "native_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}