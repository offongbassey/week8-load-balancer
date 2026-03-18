output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.web_servers[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = aws_instance.web_servers[*].public_ip
}

output "instance_availability_zones" {
  description = "Availability zones of EC2 instances"
  value       = aws_instance.web_servers[*].availability_zone
}

output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.web_servers.arn
}

output "security_group_ids" {
  description = "IDs of security groups"
  value = {
    web_servers   = aws_security_group.web_servers.id
    load_balancer = aws_security_group.load_balancer.id
  }
}

output "website_url" {
  description = "Full URL to access the load-balanced website"
  value       = "http://${aws_lb.main.dns_name}"
}