# Operations variables
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 90
}

variable "high_cpu_threshold" {
  description = "CPU utilization threshold for alerts"
  type        = number
  default     = 80
}

variable "alert_notification_emails" {
  description = "Email addresses for alert notifications"
  type        = list(string)
  default     = ["security-team@company.com"]
}