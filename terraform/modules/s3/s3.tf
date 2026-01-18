resource "aws_s3_bucket" "web_host" {
  bucket = "CV-Web-Bucket-48876"

  tags = {
    Name = "web_host"
  }
}

resource "aws_s3_bucket_website_configuration" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  index_document {
    suffix = "index.html"
  }
}

# enable object versioning
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.web_host.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.web_host.id
  key          = "index.html"
  source       = "${path.root}/../frontend/index.html"
  etag         = filemd5("${path.root}/../frontend/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "resume_pdf" {
  bucket       = aws_s3_bucket.web_host.id
  key          = "resume.pdf"
  source       = "${path.root}/../frontend/resume.pdf"
  content_type = "application/pdf"
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_host.id

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
        Resource = "${aws_s3_bucket.web_host.arn}/*"
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
