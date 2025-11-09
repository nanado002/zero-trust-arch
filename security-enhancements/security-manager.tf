# Systems Manager for patch management
resource "aws_ssm_document" "patch_baseline" {
  name          = "ZeroTrustPatchBaseline-${var.environment}"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Zero Trust Patch Management"
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "patchInstance"
        inputs = {
          runCommand = [
            "yum update -y",
            "reboot"
          ]
        }
      }
    ]
  })

  tags = var.tags
}

# Maintenance window for patching
resource "aws_ssm_maintenance_window" "patch_window" {
  name     = "zero-trust-patch-${var.environment}"
  schedule = "cron(0 2 ? * SUN *)"  # Weekly on Sunday 2 AM
  duration = 3
  cutoff   = 1

  tags = var.tags
}