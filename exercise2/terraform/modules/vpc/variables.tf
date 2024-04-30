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
  description = "The name of the cluster created."
  validation {
    condition     = length(var.name) > 0
    error_message = "The cluster name must not be empty."
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

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", var.vpc_cidr)) && cidrsubnet(var.vpc_cidr, 0, 0) != ""
    error_message = "The vpc_cidr must be a valid CIDR notation."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources created"
  default = {
    Terraform = "true"
  }
}
