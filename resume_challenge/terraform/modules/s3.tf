resource "aws_s3_bucket" "web_host" {
  bucket = "CV-Web-Bucket-48876"

  tags   = {
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
  bucket = "CV-Web-Bucket-48876"
  key    = "index.html"
  source = "${path.root}/../frontend/index.html"
  etag = filemd5("${path.root}/../frontend/index.html")
  content_type = "text/html"
}

# Change cdn distro on buck_pol

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_host.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontRead",
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::CV-Web-Bucket-48876/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::147233732413:distribution/DISTRIBUTION_ID"
        }
      }
    }
  ]
}
POLICY
}