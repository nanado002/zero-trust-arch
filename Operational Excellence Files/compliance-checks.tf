# AWS Config for compliance monitoring
resource "aws_config_configuration_recorder" "zero_trust" {
  name     = "zero-trust-recorder-${var.environment}"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  tags = var.tags
}

# Config Rules for Zero Trust compliance
resource "aws_config_config_rule" "encrypted_volumes" {
  name = "zero-trust-encrypted-volumes"

  source {
    owner             = "AWS"
    source_identifier = "EC2_ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.zero_trust]

  tags = var.tags
}