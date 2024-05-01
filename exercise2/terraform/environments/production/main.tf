# 0) VPC Module
module "vpc" {
  # Reference the VPC module from the specified source path.
  source = "../../modules/vpc"

  # Set module variables using input variables.
  region      = var.region
  profile     = var.profile
  name        = var.name
  environment = var.environment
}

# 1) EKS module
module "eks" {
  # Reference the EKS module from the specified source path.
  source = "../../modules/eks"

  # Set module variables using input variables.
  region      = var.region
  profile     = var.profile
  name        = var.name
  environment = var.environment

  # Pass the VPC ID and subnets from the VPC module to the EKS module.
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  intra_subnets   = module.vpc.intra_subnets
}

# 2) Deploy Cluster-Autoscaler
module "cluster-autoscaler" {
  # Reference the Cluster Autoscaler module from the specified source path.
  source = "../../modules/cluster-autoscaler"

  # Pass necessary variables to the Cluster Autoscaler module.
  region = var.region
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_oidc_issuer_url            = module.eks.cluster_oidc_issuer_url
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
}


# 3) Dploy the password-generator-app
module "password-generator-app"{
  # Reference the Cluster Autoscaler module from the specified source path.
  source = "../../modules/password-generator-app"

  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
}