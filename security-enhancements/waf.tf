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

  # Add your specific WAF rules here
  rule {
    name     = "ZeroTrustCustomRules"
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
      metric_name                = "ZeroTrustCustomRules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "zero-trust-waf"
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "alb_association" {
  resource_arn = aws_lb.zero_trust_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.zero_trust_waf.arn
}