output "bucket_id" {
  value = aws_s3_bucket.web_host.id
}

output "bucket_domain" {
  value = aws_s3_bucket.web_host.bucket_regional_domain_name
}