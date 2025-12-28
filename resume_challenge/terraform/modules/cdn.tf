resource "aws_cloudfront_origin_access_control" "default" {
  name                           = "cf-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior               = "always"
  signing_protocol               = "sigv4"
}

locals {
  s3_origin_id = "my-s3-origin"
  my_domain    = "ramizshefkiu.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.web_host.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ramizshefkiu.com"
  default_root_object = "index.html"

  aliases = [
    "mysite.${local.my_domain}",
    "yoursite.${local.my_domain}"
  ]

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
    
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.ssl_cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
    }

      cookies {
        forward = "none"
      }
    }
  }
}
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
