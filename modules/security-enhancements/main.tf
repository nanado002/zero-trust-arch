# Web Application Firewall with Zero Trust principles
resource "aws_wafv2_web_acl" "zero_trust_waf" {
  name        = "zero-trust-waf-${var.environment}"
  description = "Zero Trust WAF for application protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Rate limiting rule
  rule {
    name     = "RateLimit"
    priority = 2

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "zero-trust-waf"
    sampled_requests_enabled   = true
  }

  tags = var.common_tags
}

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.zero_trust_waf.arn
}

# GuardDuty Detector
resource "aws_guardduty_detector" "zero_trust" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  tags = var.common_tags
}

# SNS Topic for security alerts
resource "aws_sns_topic" "security_alerts" {
  name = "zero-trust-security-alerts-${var.environment}"
  
  tags = var.common_tags
}

# Systems Manager Patch Manager - FIXED VERSION
resource "aws_ssm_patch_baseline" "zero_trust" {
  name             = "ZeroTrustPatchBaseline-${var.environment}"
  description      = "Zero Trust Patch Baseline for EC2 instances"
  operating_system = "AMAZON_LINUX_2"

  approval_rule {
    approve_after_days  = 7
    compliance_level    = "HIGH"
    enable_non_security = true

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix"]
    }
  }

  global_filter {
    key    = "SEVERITY"
    values = ["Critical", "Important", "Medium"]
  }

  tags = var.common_tags
}

# Maintenance window for patching
resource "aws_ssm_maintenance_window" "patch_window" {
  name     = "zero-trust-patch-${var.environment}"
  schedule = "cron(0 2 ? * SUN *)"  # Weekly on Sunday 2 AM
  duration = 3
  cutoff   = 1

  tags = var.common_tags
}
