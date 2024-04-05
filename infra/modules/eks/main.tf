module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets

  eks_managed_node_groups = {
    default_node_group = {
      name                       = "${var.app_name}-node-group"
      use_custom_launch_template = false

      instance_types = var.instance_types
      capacity_type  = "SPOT"

      disk_size = 100

      desired_size = 2
      min_size     = 1
      max_size     = 5

      remote_access = {
        ec2_ssh_key               = module.key_pair.key_pair_name
        source_security_group_ids = [aws_security_group.remote_access.id]
      }

      create_iam_role          = true
      iam_role_name            = "${var.app_name}-node-group-role"
      iam_role_use_name_prefix = false
      iam_role_tags            = var.tags

      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        # AWS ALB pre-requisites for IP targets
        AmazonEKSCNI      = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AWSLoadBalancerController = aws_iam_policy.alb_controller.arn
      }

      update_config = {
        max_unavailable_percentage = 33
      }
      tags = var.tags
    }
  }

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    single-entry = {
      kubernetes_groups = []
      principal_arn     = aws_iam_role.custom_role.arn

      policy_associations = {
        single = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = var.app_name
  create_private_key = true

  tags = var.tags
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${var.app_name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.app_name}-remote" })
}
