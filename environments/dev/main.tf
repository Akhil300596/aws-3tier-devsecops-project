module "vpc" {
  source = "../../modules/vpc"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  web_subnet_cidrs    = var.web_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "load_balancers" {
  source = "../../modules/load-balancers"

  project_name                   = var.project_name
  environment                    = var.environment
  vpc_id                         = module.vpc.vpc_id
  public_subnet_ids              = module.vpc.public_subnet_ids
  app_subnet_ids                 = module.vpc.app_subnet_ids
  public_nlb_security_group_id   = module.security_groups.public_nlb_security_group_id
  internal_nlb_security_group_id = module.security_groups.internal_nlb_security_group_id
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment

  web_subnet_ids = module.vpc.web_subnet_ids
  app_subnet_ids = module.vpc.app_subnet_ids

  web_security_group_id = module.security_groups.web_security_group_id
  app_security_group_id = module.security_groups.app_security_group_id

  web_instance_profile_name = module.iam.web_instance_profile_name
  app_instance_profile_name = module.iam.app_instance_profile_name

  web_target_group_arn = module.load_balancers.web_target_group_arn
  app_target_group_arn = module.load_balancers.app_target_group_arn

  internal_nlb_dns_name = module.load_balancers.internal_nlb_dns_name
}