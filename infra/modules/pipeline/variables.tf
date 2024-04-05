variable "app_name" {
  description = "App name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(any)
}

variable "branch_name" {
  description = "Github repository's branch name"
  type        = string
}

variable "github_org" {
  description = "Github organization name"
  type        = string
}

variable "repository_name" {
  description = "Github repository name"
  type        = string
}

variable "file_paths" {
  description = "Github repository's file paths filter"
  type        = list(string)
}

variable "build_spec" {
  description = "AWS CodeBuild spec file"
  type        = string
}


variable "aws_codestarconnection_arn" {
  description = "AWS CodeStarConnection ARN for GitHub repositories' access"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repo_uri" {
  description = "ECR repo URI"
  type        = string
}

variable "cluster_iam_role_arn" {
  description = "EKS cluster IAM role ARN"
  type        = string
}

variable "k8s_file_path" {
  description = "Kubernetes YAML file path"
  type        = string
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
}
