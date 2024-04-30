variable "profile" {
  type        = string
  description = "AWS profile name to use for the deployment."
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

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., 'production', 'development', 'staging')."
  validation {
    condition     = var.environment == "production" || var.environment == "development" || var.environment == "staging"
    error_message = "The environment must be 'production', 'development', or 'staging'."
  }
}
