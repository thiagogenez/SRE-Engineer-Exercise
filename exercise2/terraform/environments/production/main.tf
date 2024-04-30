# 0) VPC Module
module "vpc" {
  source = "../../modules/vpc"

  region      = var.region
  profile     = var.profile
  name        = var.name
  environment = var.environment
}

# 1) EKS module
module "eks" {
  source = "../../modules/eks"

  region      = var.region
  profile     = var.profile
  name        = var.name
  environment = var.environment

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  intra_subnets   = module.vpc.intra_subnets

}
