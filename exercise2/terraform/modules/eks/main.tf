locals {
  # Merge additional custom tags with the base tags provided via input variables.
  tags = merge(
    var.tags,
    {
      Example     = var.name
      Environment = var.environment
      Owner       = "terraform"
    }
  )

  # Define users with access to the EKS cluster, including their ARN and group memberships.
  cluster_users = [
    {
      userarn  = "arn:aws:iam::654654572219:user/thiagogenez"
      username = "thiagogenez"
      groups   = ["system:masters"]
    }
  ]

  # Construct the cluster name by appending '-eks' to the base name.
  cluster_name = "${var.name}-eks"

  # Tags to enable autoscaling discovery for a specific node group in the EKS cluster.
  eks_asg_tag_list_nodegroup1 = {
    "k8s.io/cluster-autoscaler/enabled"           : true
    "k8s.io/cluster-autoscaler/${local.cluster_name}" : "owned"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  # Base EKS Configuration
  cluster_name             = local.cluster_name
  cluster_version          = var.cluster_version
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.intra_subnets

  # Enable both public and private access to the EKS API endpoint for this PoC.
  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = true
  enable_cluster_creator_admin_permissions = true

  # Add the default EKS cluster add-ons for CoreDNS, kube-proxy, and VPC CNI.
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

  # Default configuration for EKS managed node groups.
  eks_managed_node_group_defaults = {
    instance_types = ["t2.small", "t3.small", "t2.medium", "t2.large"]
    disk_size      = 50
    capacity_type  = "SPOT"
  }

  # Specific EKS managed node group configuration.
  eks_managed_node_groups = {
    test = {
      name            = "test"
      use_name_prefix = true
      min_size        = 1
      max_size        = 10
      desired_size    = 1

      labels = {
        env = "test"
      }

      # Apply autoscaler tags to the node group for cluster autoscaler support.
      tags                 = local.eks_asg_tag_list_nodegroup1
      launch_template_tags = local.eks_asg_tag_list_nodegroup1

      instance_types = ["t2.small", "t3.small", "t2.medium", "t2.large"]
      capacity_type  = "SPOT"

      # Update strategy configuration to limit the number of unavailable nodes during updates.
      update_config = {
        max_unavailable_percentage = 10
      }

      # Additional IAM policies to be attached to the node group's IAM role.
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      description = "EKS managed node group test"
    }
  }

  # Apply tags to the EKS cluster and related resources.
  tags = local.tags
}

# Apply autoscaling tags to the specified autoscaling group.
resource "aws_autoscaling_group_tag" "nodegroup1" {
  for_each               = local.eks_asg_tag_list_nodegroup1
  autoscaling_group_name = element(module.eks.eks_managed_node_groups_autoscaling_group_names, 0)

  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}
