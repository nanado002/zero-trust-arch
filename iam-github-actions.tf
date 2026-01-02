# IAM User for GitHub Actions CI/CD
resource "aws_iam_user" "github_actions" {
  name = "github-actions-zero-trust"
  tags = {
    Purpose = "CI/CD deployments for Zero Trust Architecture"
  }
}

# IAM Policy for GitHub Actions
resource "aws_iam_user_policy" "github_actions_policy" {
  name = "GitHubActionsZeroTrustPolicy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "wafv2:*",
          "guardduty:*",
          "ssm:*",
          "sns:*",
          "cloudwatch:*",
          "iam:PassRole",
          "secretsmanager:GetSecretValue",
          "logs:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" : "us-east-1"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the access key (you'll need to manually create and add to GitHub secrets)
output "github_actions_user_arn" {
  value       = aws_iam_user.github_actions.arn
  description = "ARN of the GitHub Actions IAM user"
  sensitive   = false
}
