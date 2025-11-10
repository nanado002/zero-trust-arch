locals {
  common_tags = {
    Project     = "Zero-Trust-Architecture"
    Terraform   = "true"
    Environment = var.environment
    Repository  = "https://github.com/yourusername/aws-zero-trust"
  }
}