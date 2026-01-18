variable "bucket_id" {
  type = string
}

variable "bucket_domain" {
  type = string
}

variable "acm_cert_arn" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "ramizshefkiu.com"
}

variable "domain_aliases" {
  type    = list(string)
  default = ["mysite.ramizshefkiu.com", "yoursite.ramizshefkiu.com"]
}
