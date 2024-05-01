# EKS Cluster Setup with Cluster Autoscaler and Password Generator App

This Terraform code provisions an AWS EKS cluster and sets up a password generator application. The setup follows best practices for high availability and principle of least privilege.

## Modules Overview

### 0) VPC Module
This module provisions the Virtual Private Cloud (VPC) that is used to host the EKS cluster. It takes the following variables:
- `region`: The AWS region where the VPC will be created.
- `profile`: The AWS profile to use for authentication.
- `name`: The base name for the VPC resources.
- `environment`: The environment in which this infrastructure will run.

### 1) EKS Module
This module provisions the EKS cluster using the VPC resources created in the previous step. It takes the following variables:
- `region`: The AWS region where the EKS cluster will be created.
- `profile`: The AWS profile to use for authentication.
- `name`: The base name for the EKS resources.
- `environment`: The environment in which this infrastructure will run.
- `vpc_id`: The ID of the VPC where the EKS cluster will be created.
- `private_subnets`: A list of private subnets in the VPC.
- `intra_subnets`: A list of intra subnets in the VPC.

### 2) Deploy Cluster-Autoscaler
This module sets up the Cluster Autoscaler to automatically scale the EKS cluster based on resource demands. It takes the following variables:
- `region`: The AWS region where the EKS cluster is running.
- `cluster_name`: The name of the EKS cluster.
- `cluster_endpoint`: The endpoint URL of the EKS cluster.
- `cluster_oidc_issuer_url`: The OIDC issuer URL of the EKS cluster.
- `cluster_certificate_authority_data`: The base64 encoded certificate authority data of the EKS cluster.

### 3) Deploy Password Generator App
This module sets up the password generator application to run on the EKS cluster. It takes the following variables:
- `cluster_name`: The name of the EKS cluster.
- `cluster_endpoint`: The endpoint URL of the EKS cluster.
- `cluster_certificate_authority_data`: The base64 encoded certificate authority data of the EKS cluster.
- `app_name`: The name of the application.
- `namespace`: The Kubernetes namespace where the application will be deployed.
- `repository`: The Docker image repository for the application.

## How to Use

### Prerequisites
- Terraform installed (v0.12 or later).
- AWS credentials configured with sufficient permissions.

### Usage
1. Prepare a `production.tfvars.json` file with the following content:
    ```json
    {
        "region": "eu-central-1",
        "name": "interview-eks-cluster",
        "profile": "default",
        "environment": "production"
    }
    ```
2. Run the following Terraform command to apply the configuration:
    ```bash
    terraform apply -var-file="production.tfvars.json" -auto-approve
    ```

This will provision the AWS EKS cluster, set up the Cluster Autoscaler, and deploy the password generator application as specified in the Terraform code.
