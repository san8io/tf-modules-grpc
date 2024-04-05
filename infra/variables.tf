variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "hosted_zone_id" {
  description = "AWS Route53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "App domain names"
  type        = list(string)
}

variable "aws_codestarconnection_arn" {
  description = "AWS CodeStart connection ARN for GitHub repository access"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
