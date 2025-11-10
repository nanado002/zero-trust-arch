# security_groups.tf - Zero Trust Security Groups

# Security Group for Load Balancer
resource "aws_security_group" "zt_gateway_sg" {
  name        = "zt-gateway-sg"
  description = "Security group for Zero Trust Gateway/ALB"
  vpc_id      = aws_vpc.zero_trust_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zt-gateway-sg"
  }
}

# Security Group for Web Tier
resource "aws_security_group" "web_sg" {
  name        = "web-tier-sg"
  description = "Security group for web tier - only allows traffic from ALB"
  vpc_id      = aws_vpc.zero_trust_vpc.id

  ingress {
    description     = "HTTP only from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.zt_gateway_sg.id]
  }

  ingress {
    description = "SSH from anywhere (for management)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-tier-sg"
  }
}

# Security Group for Application Tier
resource "aws_security_group" "app_sg" {
  name        = "app-tier-sg"
  description = "Security group for app tier - only allows traffic from web tier"
  vpc_id      = aws_vpc.zero_trust_vpc.id

  ingress {
    description     = "App port only from web tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description = "SSH from anywhere (for management)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-tier-sg"
  }
}

# Security Group for Database Tier
resource "aws_security_group" "db_sg" {
  name        = "db-tier-sg"
  description = "Security group for database tier - only allows traffic from app tier"
  vpc_id      = aws_vpc.zero_trust_vpc.id

  ingress {
    description     = "MySQL only from app tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  ingress {
    description = "SSH from anywhere (for management)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-tier-sg"
  }
}
