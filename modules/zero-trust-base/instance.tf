# Web Tier Instances with for_each
resource "aws_instance" "web_servers" {
  for_each = {
    "web-1" = 0
    "web-2" = 1
  }

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[each.value].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.zero_trust_key.key_name

  user_data                   = <<-EOF
#!/bin/bash
  set -euxo pipefail
  (yum -y update || true)
  amazon-linux-extras enable nginx1
  yum -y clean metadata
  yum -y install nginx
  systemctl enable --now nginx
  echo "<html><body><h1>Web Server ${each.key}</h1><p>Zero Trust Architecture</p></body></html>" > /usr/share/nginx/html/index.html
  EOF
  user_data_replace_on_change = true


  tags = {
    Name = each.key
    Tier = "Web"
  }
}

# Attach Web Instances to ALB Target Group with static for_each
resource "aws_lb_target_group_attachment" "web" {
  for_each = {
    "web-1" = 0
    "web-2" = 1
  }

  target_group_arn = aws_lb_target_group.web_tier.arn
  target_id        = aws_instance.web_servers[each.key].id
  port             = 80
}

# Database Instance
resource "aws_instance" "database" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = aws_key_pair.zero_trust_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              echo "Database Server - Ready" > /home/ec2-user/status.txt
              EOF

  tags = {
    Name = "database-server"
    Tier = "Database"
  }
}

# "Attacker" instance for testing
resource "aws_instance" "attacker" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.zt_gateway_sg.id]
  key_name               = aws_key_pair.zero_trust_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nmap telnet
              echo "Attacker instance - for security testing" > /home/ec2-user/README.txt
              EOF

  tags = {
    Name    = "attacker-test-instance"
    Purpose = "Security Testing"
  }
}




# Amazon Linux 2 AMI data source
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
