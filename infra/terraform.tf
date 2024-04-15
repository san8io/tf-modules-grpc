terraform {

  backend "s3" {
    bucket = "bucket-terraform"
    key    = "bucket/terraform.tfstate"
    region = "us-east-2"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.13.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.17.0"
    }
  }

  required_version = ">= 1.3"
}

