

locals {
  private_key = data.aws_secretsmanager_secret_version.ssh_key.secret_string
}