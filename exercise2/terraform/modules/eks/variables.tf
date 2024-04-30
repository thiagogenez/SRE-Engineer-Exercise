variable "profile" {
  type        = string
  description = "AWS profile name to use for the deployment."
  default     = "default"
  validation {
    condition     = length(var.profile) > 0
    error_message = "The AWS profile name must not be empty."
  }
}

variable "region" {
  type        = string
  description = "AWS region where the resources will be created."
}

variable "name" {
  type        = string
  description = "The name of the cluster to be created."
  validation {
    condition     = length(var.name) > 0
    error_message = "The cluster name must not be empty."
  }
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources created"
  default = {
    Terraform = "true"
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., 'production', 'development', 'staging')."
  validation {
    condition     = var.environment == "production" || var.environment == "development" || var.environment == "staging"
    error_message = "The environment must be 'production', 'development', or 'staging'."
  }
}

################################################################################
# Variables from VPC module
################################################################################

variable "vpc_id" {
  description = "The ID of the Default VPC"
  type        = string
}

variable "private_subnets" {
  description = "A list of IDs of private subnets inside the VPC"
  type        = list(any)
}

variable "intra_subnets" {
  description = "A List of IDs of intra subnets inside the VPC"
  type        = list(any)
}

