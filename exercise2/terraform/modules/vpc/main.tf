data "aws_availability_zones" "available" {
  state = "available"
}
# data "aws_caller_identity" "current" {

# }

locals {
  tags = merge(
    var.tags,
    {
      Example     = var.name
      Environment = var.environment
    }
  )
  #   azs = slice(
  #     data.aws_availability_zones.available.names, 0, length(data.aws_availability_zones.available.names)
  #   )
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 8)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 16)]
}


# VPC Module Configuration
# This sets up a highly available VPC across multiple availability zones
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name            = "${var.name}-vpc"
  cidr            = var.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  # Use a NAT Gateway per AZ for high availability
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags

  # Tags for subnets
  public_subnet_tags = {
    # Marks these subnets as suitable for internet-facing load balancers
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    # Marks these subnets as suitable for internal load balancers
    "kubernetes.io/role/internal-elb" = 1
  }
}

