module "frontend_s3" {
  source = "./modules/s3"
}

module "dns" {
  source = "./modules/route53"
  acm_cert_arn = "arn:aws:acm:us-east-1:147237732413:certificate/33c96b5f-d9ff-428b-a987-8503be5d8264"
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