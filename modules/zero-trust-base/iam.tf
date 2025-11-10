# iam.tf - IAM roles and policies
resource "aws_iam_role" "ec2_role" {
  name = "zero-trust-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = "zero-trust-poc"
  }
}

# Basic policy for EC2 instances
resource "aws_iam_role_policy" "ec2_basic_policy" {
  name = "ec2-basic-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "zero-trust-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
