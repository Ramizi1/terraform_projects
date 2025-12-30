resource "aws_apigatewayv2_api" "visitor_api" {
  name          = "visitor_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "visitor_integration" {
  api_id           = aws_apigatewayv2_api.visitor_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_visitor_count.arn
}

resource "aws_apigatewayv2_route" "visitor_route" {
  api_id    = aws_apigatewayv2_api.visitor_api.id
  route_key = "ANY /count"
  target    = "integrations/${aws_apigatewayv2_integration.visitor_integration.id}"
}

resource "aws_apigatewayv2_stage" "visitor_stage" {
  api_id = aws_apigatewayv2_api.visitor_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_APIGW" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_visitor_count.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor_api.execution_arn}/*/*"
}