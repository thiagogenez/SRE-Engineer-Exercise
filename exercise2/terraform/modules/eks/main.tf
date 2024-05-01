# data "aws_caller_identity" "current" {}

# data "aws_iam_session_context" "current" {
#   # This data source provides information on the IAM source role of an STS assumed role
#   # For non-role ARNs, this data source simply passes the ARN through issuer ARN
#   # Ref https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
#   # Ref https://github.com/hashicorp/terraform-provider-aws/issues/28381
#   arn = data.aws_caller_identity.current.arn
# }

locals {
  tags = merge(
    var.tags,
    {
      Example     = var.name
      Environment = var.environment
    }
  )
}

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
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
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true
  kms_key_administrators                   = ["arn:aws:iam::654654572219:user/thiagogenez"]

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
    instance_types = ["t2.small", "t3.small", "t2.medium", "t2.large"]
    disk_size      = 50
    capacity_type  = "SPOT"
  }

  eks_managed_node_groups = {
    test = {
      name            = "test"
      use_name_prefix = true
      min_size     = 1
      max_size     = 10
      desired_size = 1

      labels = {
        env = "test"
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${var.name}" = "owned"
      }

      launch_template_tags = {
        # enable discovery of autoscaling groups by cluster-autoscaler
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${var.name}" : "owned",
      }

      instance_types = ["t2.small", "t3.small", "t2.medium", "t2.large"]
      capacity_type  = "SPOT"
      ami_id = data.aws_ami.eks_default.image_id
      force_update_version = true

      update_config = {
        max_unavailable_percentage = 33 
      }

      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      description = "EKS managed node group test"
    }
  }

  tags = local.tags
}


