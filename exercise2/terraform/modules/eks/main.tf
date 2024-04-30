
locals {
  tags = merge(
    var.tags,
    {
      Example     = var.name
      Environment = var.environment
    }
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"


  # Base EKS Configuration
  cluster_name             = "${var.name}-eks"
  cluster_version          = var.cluster_version
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  # to set accordinally as this a PoC only
  cluster_endpoint_public_access = true
  create_kms_key                 = false
  create_cloudwatch_log_group    = false
  cluster_encryption_config      = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.micro"]
    disk_size      = 50
  }

  eks_managed_node_groups = {
    blue = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "blue"
      }

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = local.tags
}


