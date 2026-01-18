module "frontend_s3" {
  source = "./modules/s3"
}

module "cdn" {
  source = "./modules/cloudfront"
}

module "dns" {
  source = "./modules/route53"
}

module "backend" {
  source = "./modules/backend"
}