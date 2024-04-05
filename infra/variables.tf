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