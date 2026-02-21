variable "bucket_id" {
  type        = string
  description = "The S3 bucket ID to use as CloudFront origin"
}

variable "bucket_domain" {
  type        = string
  description = "The S3 bucket regional domain name"
}

variable "acm_cert_arn" {
  type        = string
  description = "Existing ACM certificate ARN for CloudFront"
  default     = "arn:aws:acm:us-east-1:147237732413:certificate/33c96b5f-d9ff-428b-a987-8503be5d8264"
}

variable "domain_name" {
  type        = string
  description = "The main domain name for CloudFront"
  default     = "ramizshefkiu.com"
}

variable "domain_aliases" {
  type        = list(string)
  description = "CloudFront alternate domain names (CNAMEs)"
  default     = ["ramizshefkiu.com"]
}
