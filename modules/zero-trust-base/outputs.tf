# Output values for the base module - reference resources directly
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.zero_trust_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.zero_trust_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "ID of ALB security group"
  value       = aws_security_group.zt_gateway_sg.id
}

output "web_security_group_id" {
  description = "ID of web tier security group"
  value       = aws_security_group.web_sg.id
}

output "app_security_group_id" {
  description = "ID of app tier security group"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "ID of database tier security group"
  value       = aws_security_group.db_sg.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.zero_trust_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.zero_trust_alb.arn
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.zero_trust_alb.zone_id
}

output "web_instance_ids" {
  description = "IDs of web tier instances"
  value       = try(aws_instance.web_servers[*].id, [for k, v in aws_instance.web_servers : v.id])
}

output "db_instance_ids" {
  description = "IDs of database tier instances"
  value       = try(aws_instance.database[*].id, [for k, v in aws_instance.database : v.id])
}

output "attacker_instance_ids" {
  description = "IDs of attacker instances"
  value       = try(aws_instance.attacker[*].id, [for k, v in aws_instance.attacker : v.id])
}
