# Retrieve a list of available availability zones in the current AWS region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables and calculated values.
locals {
  # Merging additional tags into the main tags set.
  tags = merge(
    var.tags,
    {
      Example     = var.name
      Environment = var.environment
    }
  )
  
  # Get a list of the first three available availability zones.
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  
  # Generate private subnets by assigning each availability zone a subnet.
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k)]
  
  # Generate public subnets by assigning each availability zone a different subnet with a different range.
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 8)]
  
  # Generate intra subnets for each availability zone, each with a different range.
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 16)]
}

# VPC Module Configuration
# This sets up a highly available VPC across multiple availability zones.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  # Name of the VPC using the specified variable name.
  name = "${var.name}-vpc"
  
  # Assigning the CIDR block and availability zones for the VPC.
  cidr = var.vpc_cidr
  azs  = local.azs
  
  # Assigning subnets to the VPC.
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  # Enable NAT Gateways for internet access in the VPC.
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # Enable DNS support and hostnames within the VPC.
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Assign tags to the VPC and its subnets.
  tags = local.tags

  # Tags specifically for public subnets, making them suitable for internet-facing load balancers.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  # Tags specifically for private subnets, making them suitable for internal load balancers.
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
