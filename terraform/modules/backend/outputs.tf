output "api_url" {
  value = "${aws_apigatewayv2_api.visitor_api.api_endpoint}/count"
}