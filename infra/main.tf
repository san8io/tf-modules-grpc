provider "aws" {
  region = var.region
}

locals {
  cluster_name = "${var.app_name}-eks"
  tags = {
    Organization = "project"
    Environment = var.environment
  }
}

module "vpc_network" {
  source          = "./modules/vpc"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  app_name        = var.app_name
  cidr            = "10.0.0.0/16"
  cluster_name    = local.cluster_name
  tags            = local.tags
}

module "eks_cluster" {
  source              = "./modules/eks"
  app_name            = var.app_name
  instance_types      = ["t3.xlarge"]
  vpc_id              = module.vpc_network.outputs.vpc_id
  vpc_private_subnets = module.vpc_network.outputs.vpc_private_subnets
  cluster_name        = local.cluster_name
  tags                = local.tags
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

module "ecr_client" {
  source   = "./modules/ecr"
  app_name = "${var.app_name}-client"
  tags     = local.tags
}

module "ecr_server" {
  source   = "./modules/ecr"
  app_name = "${var.app_name}-server"
  tags     = local.tags
}

module "client_pipeline" {
  source                     = "./modules/pipeline"
  app_name                   = var.app_name
  branch_name                = "main"
  github_org                 = "github-org"
  repository_name            = "repo-name"
  file_paths                 = ["client"]
  build_spec                 = file("templates/buildspec.yml")
  aws_codestarconnection_arn = var.aws_codestarconnection_arn
  environment                = var.environment
  repo_uri                   = module.ecr_client.outputs.repo_uri
  cluster_iam_role_arn       = module.eks_cluster.outputs.cluster_iam_role_arn
  k8s_file_path              = "client/application.yml"
  ecr_repository_name        = module.ecr_client.outputs.repo_name
  tags                       = local.tags
}

module "server_pipeline" {
  source                     = "./modules/pipeline"
  app_name                   = var.app_name
  branch_name                = "main"
  github_org                 = "github-org"
  repository_name            = "tf-modules-grpc"
  file_paths                 = ["server"]
  build_spec                 = file("templates/buildspec.yml")
  aws_codestarconnection_arn = var.aws_codestarconnection_arn
  environment                = var.environment
  repo_uri                   = module.ecr_server.outputs.repo_uri
  cluster_iam_role_arn       = module.eks_cluster.outputs.cluster_iam_role_arn
  k8s_file_path              = "server/application.yml"
  ecr_repository_name        = module.ecr_server.outputs.repo_name
  tags                       = local.tags
}
