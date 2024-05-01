variable "region" {
  type        = string
  description = "AWS region where the resources will be created."
}

variable "cluster_oidc_issuer_url" {
  description = "The OIDC Issuer URL for the EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the cluster."
  type        = string
}
