output "vpc_details" {
  description = "Aggregate of VPC details including IDs, ARNs, and CIDR blocks of private subnets"
  value = jsonencode({
    vpc_id               = module.vpc.vpc_id
    vpc_arn              = module.vpc.vpc_arn
    private_subnet_ids   = module.vpc.private_subnets
    private_subnet_arns  = module.vpc.private_subnet_arns
    private_subnet_cidrs = module.vpc.private_subnets_cidr_blocks
  })
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra_subnets"
  value       = module.vpc.intra_subnets
}


output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}
