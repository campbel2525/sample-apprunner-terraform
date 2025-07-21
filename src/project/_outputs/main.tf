# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = var.aws_default_profile
}

# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
  }

  backend "s3" {
    key = "outputs/terraform.tfstate"
  }
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
# 共通
module "current_account" {
  source = "../../modules/get_aws_account"
}

# rds
module "rds" {
  source = "../../modules/get_rds"

  db_instance_identifier = "db1-mysql-standalone"
}

# user_front
module "user_front_apprunner" {
  source = "../../modules/get_apprunner"

  service_name = "user-front-apprunner-service"

  providers = {
    aws = aws
  }
}

module "user_front_ecr" {
  source = "../../modules/get_ecr"

  repository_name = "user-front-repo"
}

module "user_front_github_actions_role" {
  source = "../../modules/get_role"

  role_name = "user-front-apprunner-github-actions-role"
}
