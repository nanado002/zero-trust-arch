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

# Phase 1: Security Enhancements
module "security_enhancements" {
  source = "./modules/security-enhancements"
  
  environment = var.environment
  alb_arn     = module.zero_trust_base.alb_arn
  vpc_id      = module.zero_trust_base.vpc_id
  common_tags = local.common_tags
  
  depends_on = [module.zero_trust_base]
}