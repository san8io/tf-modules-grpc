output "vpc_id" {
  description = "AWS VPC id"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "AWS VPC private subnets"
  value       = module.vpc.private_subnets
}
