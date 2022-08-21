terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"

  cloud {
    organization = "chuanfrost98"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
