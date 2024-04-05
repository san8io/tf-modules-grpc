variable "availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "private_subnets" {
  description = "AWS VPC private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "AWS VPC public subnets"
  type        = list(string)
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "cidr" {
  description = "CIDR address range"
  type        = string
}

variable "cluster_name" {
  description = "AWS EKS cluster name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map
}