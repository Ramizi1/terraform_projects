resource "aws_acm_certificate" "acm_cert" {
  provider          = "var.region"
  domain_name       = "ramizshefkiu.com"
  validation_method = "DNS"
  subject_alternative_names = ["www.ramizshefkiu.com"]
}

output "acm_validation" {
  value       = aws_acm_certificate.acm_cert.domain_validation_options
  description = "Add these TXT records in Namecheap to validate ACM certificate"
}

viewer_certificate {
  acm_certificate_arn = aws_acm_certificate.ssl_cert.arn
  ssl_support_method = "sni-only"
  minimum_protocol_version = "TLSv1.2_2019"
}
