
output "cluster_oidc_issuer_url" {
  description = "The OIDC Issuer URL for the EKS cluster."
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the cluster."
  value       = module.eks.cluster_certificate_authority_data
}
