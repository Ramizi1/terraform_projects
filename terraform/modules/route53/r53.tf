resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "ramizshefkiu.com"
  validation_method = "DNS"
  subject_alternative_names = ["www.ramizshefkiu.com"]
}

output "acm_validation" {
  value       = aws_acm_certificate.acm_cert.domain_validation_options
  description = "Add these TXT records in Namecheap to validate ACM certificate"
}
