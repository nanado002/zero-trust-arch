data "aws_secretsmanager_secret" "ssh_key" {
  name = "prod/ssh/zero-trust-key"
}

data "aws_secretsmanager_secret_version" "ssh_key" {
  secret_id = data.aws_secretsmanager_secret.ssh_key.id
}

resource "aws_key_pair" "zero_trust_key" {
  key_name   = "zero-trust-key"
  public_key = data.aws_secretsmanager_secret_version.ssh_key.secret_string
}