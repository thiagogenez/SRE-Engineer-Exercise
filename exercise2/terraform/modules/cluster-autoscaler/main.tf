locals {
  # Local variables to define the Kubernetes service account namespace and name.
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler"
}

# Deploy the Cluster Autoscaler using a Helm chart.
resource "helm_release" "cluster-autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = local.k8s_service_account_namespace
  repository       = "https://kubernetes.github.io/autoscaler/"
  chart            = "cluster-autoscaler"
  version          = "9.36.0"
  create_namespace = false # Do not create the namespace since it should already exist.

  # Set the AWS region for the Cluster Autoscaler.
  set {
    name  = "awsRegion"
    value = var.region
  }

  # Set the service account name to be used by the Cluster Autoscaler.
  set {
    name  = "rbac.serviceAccount.name"
    value = local.k8s_service_account_name
  }

  # Set the IAM role ARN associated with the service account for permissions.
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
    type  = "string"
  }

  # Set the EKS cluster name for Cluster Autoscaler to auto-discover nodes.
  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  # Enable auto-discovery of nodes by the Cluster Autoscaler.
  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  # Enable role-based access control (RBAC) for the Cluster Autoscaler.
  set {
    name  = "rbac.create"
    value = "true"
  }
}

# Module to create an IAM role with the necessary permissions for the Cluster Autoscaler.
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "cluster-autoscaler"

  # Replace 'https://' in the OIDC issuer URL to get the provider URL.
  provider_url                  = replace(var.cluster_oidc_issuer_url, "https://", "")
  
  # Attach policy ARNs to the role.
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]

  # Allow the role to be assumed by the Kubernetes service account.
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}

# IAM policy to grant the Cluster Autoscaler required permissions.
resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

# Document defining the IAM policy for the Cluster Autoscaler.
data "aws_iam_policy_document" "cluster_autoscaler" {
  # Policy statement to grant read-only permissions for autoscaling and EC2 actions.
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  # Policy statement to allow the Cluster Autoscaler to modify the scaling group it owns.
  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    # Conditions to ensure that permissions are granted only to the specific Cluster Autoscaler group.
    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}
