# outputs.tf - Output values
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.zero_trust_vpc.id
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.zero_trust_alb.dns_name
}

output "web_servers_public_ips" {
  description = "Web servers public IPs"
  value       = [for k, server in aws_instance.web_servers : server.public_ip]
}

output "web_servers_private_ips" {
  description = "Web servers private IPs"
  value       = [for k, server in aws_instance.web_servers : server.private_ip]
}

output "database_private_ip" {
  description = "Database server private IP"
  value       = aws_instance.database.private_ip
}

output "attacker_instance_ip" {
  description = "Attacker test instance public IP"
  value       = aws_instance.attacker.public_ip
}

output "zero_trust_key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.zero_trust_key.key_name
}