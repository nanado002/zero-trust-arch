# Centralized Logging
resource "aws_cloudwatch_log_group" "zero_trust_app" {
  name              = "/aws/zero-trust/${var.environment}/application"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# CloudWatch Logs Insights queries
resource "aws_cloudwatch_query_definition" "security_queries" {
  name = "zero-trust-security-queries"

  log_group_names = [
    aws_cloudwatch_log_group.zero_trust_app.name,
    "vpc-flow-logs"
  ]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like /ERROR/ or @message like /DENY/
| sort @timestamp desc
| limit 20
EOF
}