# Security-specific variables
variable "waf_managed_rules" {
  description = "List of AWS Managed Rules for WAF"
  type        = list(string)
  default = [
    "AWSManagedRulesCommonRuleSet",
    "AWSManagedRulesKnownBadInputsRuleSet",
    "AWSManagedRulesSQLiRuleSet"
  ]
}

variable "guardduty_finding_severity" {
  description = "Minimum severity level for GuardDuty alerts"
  type        = string
  default     = "MEDIUM"
}

variable "patch_schedule" {
  description = "CRON expression for patch management"
  type        = string
  default     = "cron(0 2 ? * SUN *)"
}