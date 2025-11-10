terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

# Base Zero Trust Infrastructure Module
module "zero_trust_base" {
  source = "./modules/zero-trust-base"
  
  environment         = var.environment
  vpc_cidr           = var.vpc_cidr
  aws_region         = var.aws_region
  enable_vpc_flow_logs = var.enable_vpc_flow_logs
}
