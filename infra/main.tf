provider "aws" {
  region = var.region
}

locals {
  cluster_name = "${var.app_name}-eks"
}

module "vpc_simetrik" {
  source          = "./modules/vpc"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  app_name        = var.app_name
  cidr            = "10.0.0.0/16"
  cluster_name    = local.cluster_name
}

module "eks_simetrik" {
  source              = "./modules/eks"
  app_name            = var.app_name
  instance_types      = ["t3.xlarge"]
  vpc_id              = module.vpc_simetrik.outputs.vpc_id
  vpc_private_subnets = module.vpc_simetrik.outputs.vpc_private_subnets
  cluster_name        = local.cluster_name
}

data "aws_eks_cluster_auth" "idp_svc" {
  name = local.cluster_name
}
