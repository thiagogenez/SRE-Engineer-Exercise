variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "app_name" {
  description = "The name of the app."
  type        = string
}

variable "repository" {
  description = "The name of the app's repository."
  type        = string
}

variable "namespace" {
  description = "The name of the namespace the app will be deployed."
  type        = string
  default     = "default"
}

variable "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the cluster."
  type        = string
}
