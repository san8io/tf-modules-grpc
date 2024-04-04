module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    # vpc-cni    = {}
  }

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.vpc_private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      name                       = "${var.app_name}-node-group"
      use_custom_launch_template = false

      instance_types = var.instance_types
      capacity_type  = "SPOT"

      disk_size = 100

      desired_size = 2
      min_size     = 1
      max_size     = 3
    }
  }
}