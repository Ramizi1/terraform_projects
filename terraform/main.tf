module "frontend_s3" {
  source = "./modules/s3"
}

module "dns" {
  source = "./modules/route53"
}

module "cdn" {
  source = "./modules/cloudfront"

  bucket_id     = module.frontend_s3.bucket_id
  bucket_domain = module.frontend_s3.bucket_domain
  acm_cert_arn  = module.dns.acm_cert_arn
}

module "backend" {
  source = "./modules/backend"
}