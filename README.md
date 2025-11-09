# AWS Zero Trust Architecture - Terraform

## Overview
Implementation of Zero Trust security model in AWS VPC using Terraform.

## Architecture
- **VPC** with public/private subnets
- **Application Load Balancer** as Zero Trust gateway
- **Micro-segmentation** between Web, App, and Database tiers
- **Security Groups** enforcing least privilege access

## Phases
- **Phase 1**: Base Zero Trust Architecture ✅
- **Phase 2**: Enhanced Security (WAF, GuardDuty, Systems Manager)
- **Phase 3**: Operational Excellence (Monitoring, Compliance, Backup)

## Usage
```bash
terraform init
terraform plan
terraform apply

