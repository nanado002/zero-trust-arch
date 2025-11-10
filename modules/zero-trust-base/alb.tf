# alb.tf - Application Load Balancer (Zero Trust Gateway)
resource "aws_lb" "zero_trust_alb" {
  name               = "zero-trust-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.zt_gateway_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "zero-trust-alb"
  }
}

# Target Group for Web Servers
resource "aws_lb_target_group" "web_tier" {
  name     = "web-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.zero_trust_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "web-tier-target-group"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.zero_trust_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tier.arn
  }

  tags = {
    Name = "http-listener"
  }
}
