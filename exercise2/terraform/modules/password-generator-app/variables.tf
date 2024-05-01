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
