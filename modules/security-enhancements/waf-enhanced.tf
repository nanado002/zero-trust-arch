# Enhanced WAF with more aggressive rules
resource "aws_wafv2_web_acl" "zero_trust_waf_enhanced" {
  name        = "zero-trust-waf-enhanced-${var.environment}"
  description = "Enhanced Zero Trust WAF with aggressive SQL injection and XSS protection"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # SQL Injection Rules
  rule {
    name     = "SQLInjection"
    priority = 1

    action {
      block {}
    }

    statement {
      sqli_match_statement {
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 1
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjection"
      sampled_requests_enabled   = true
    }
  }

  # XSS Rules
  rule {
    name     = "XSS"
    priority = 2

    action {
      block {}
    }

    statement {
      xss_match_statement {
        field_to_match {
          query_string {}
        }
        text_transformation {
          priority = 1
          type     = "URL_DECODE"
        }
        text_transformation {
          priority = 2
          type     = "HTML_ENTITY_DECODE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSS"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rules - Common Attacks
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 3

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

  # AWS Managed Rules - SQL Injection
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Rate limiting rule
  rule {
    name     = "RateLimit"
    priority = 5

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000 # More aggressive rate limit
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
    metric_name                = "zero-trust-waf-enhanced"
    sampled_requests_enabled   = true
  }

  tags = var.common_tags
}

# Associate enhanced WAF with ALB
resource "aws_wafv2_web_acl_association" "alb_association_enhanced" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.zero_trust_waf_enhanced.arn

  depends_on = [aws_wafv2_web_acl.zero_trust_waf_enhanced]
}
