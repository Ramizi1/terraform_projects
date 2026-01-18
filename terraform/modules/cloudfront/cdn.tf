resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cf-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "my-s3-origin"
}

# PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_public_access_block" "web_host" {
  bucket = var.bucket_id # <- use module input!

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CLOUDFRONT DISTRIBUTION
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.bucket_domain
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.domain_name}"
  default_root_object = "index.html"

  aliases = var.domain_aliases

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # ✅ REQUIRED: at least one restrictions block
  restrictions {
    geo_restriction {
      restriction_type = "none" # no restrictions
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}


resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontRead"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.bucket_id}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.s3_distribution]
}