output "api_url" {
  value = "${aws_apigatewayv2_api.visitor_api.api_endpoint}/count"
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
