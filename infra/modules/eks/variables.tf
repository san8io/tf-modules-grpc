variable "app_name" {
  description = "App name"
  type        = string
}

variable "instance_types" {
  description = "AWS EC2 instance types"
  type        = list(string)
}

variable "vpc_id" {
  description = "AWS VPC id"
  type        = string
}

variable "vpc_private_subnets" {
  description = "AWS VPC private subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "AWS EKS cluster name"
  type        = string
}

