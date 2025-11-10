output "waf_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.zero_trust_waf.arn
}

output "waf_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.zero_trust_waf.id
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.zero_trust.id
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for security alerts"
  value       = aws_sns_topic.security_alerts.arn
}

output "patch_baseline_id" {
  description = "ID of the SSM patch baseline"
  value       = aws_ssm_patch_baseline.zero_trust.id
}

output "maintenance_window_id" {
  description = "ID of the SSM maintenance window"
  value       = aws_ssm_maintenance_window.patch_window.id
}