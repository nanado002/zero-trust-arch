# Enhanced CloudWatch Alarms
resource "aws_cloudwatch_dashboard" "zero_trust" {
  dashboard_name = "Zero-Trust-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.zero_trust_alb.arn_suffix],
            [".", "HTTPCode_Target_5XX_Count", ".", "."],
            [".", "HTTPCode_Target_4XX_Count", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          title   = "ALB Request Metrics"
          period  = 300
        }
      }
    ]
  })

  tags = var.tags
}

# Custom metrics alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "zero-trust-high-cpu-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_sns_topic.operational_alerts.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_tier.name
  }

  tags = var.tags
}