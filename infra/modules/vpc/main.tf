module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.app_name}-vpc"

  cidr = var.cidr
  azs  = var.availability_zones

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${var.app_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${var.app_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.app_name}-default" }

  public_subnet_tags = {
    # AWS ALB pre-requisites
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    # AWS ALB pre-requisites
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = var.tags
}