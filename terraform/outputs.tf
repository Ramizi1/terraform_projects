output "api_url" {
  value = module.backend.api_url
}

output "cloudfront_domain" {
  value = module.cdn.cloudfront_domain
}