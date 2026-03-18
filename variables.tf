# ==========================================
# VARIABLES - CONFIGURABLE VALUES
# ==========================================
# Variables let you customize the infrastructure
# Think of them like settings in a video game
# You can change these without changing the code

# ==========================================
# AWS Region Variable
# ==========================================
variable "aws_region" {
  # Description: What this variable is for
  description = "AWS region where resources will be created"
  
  # Type: What kind of value (string = text)
  type        = string
  
  # Default: The value if you don't specify one
  default     = "eu-west-1"
  
  # Why eu-west-1? It's Ireland - close to you, good pricing
}

# ==========================================
# Project Name Variable
# ==========================================
variable "project_name" {
  # This will be used to name all resources
  # Example: week8-lb-vpc, week8-lb-subnet1, etc.
  description = "Name prefix for all resources"
  type        = string
  default     = "week8-lb"
  
  # "lb" stands for "load balancer"
}

# ==========================================
# VPC CIDR Block Variable
# ==========================================
variable "vpc_cidr" {
  # CIDR = Classless Inter-Domain Routing
  # 10.0.0.0/16 means:
  # - 10.0.0.0 is the starting IP address
  # - /16 means we have 65,536 IP addresses available
  # - Range: 10.0.0.0 to 10.0.255.255
  
  description = "CIDR block for VPC (network address range)"
  type        = string
  default     = "10.0.0.0/16"
}

# ==========================================
# Public Subnet 1 CIDR
# ==========================================
variable "public_subnet_1_cidr" {
  # This is a smaller chunk of the VPC
  # 10.0.1.0/24 means:
  # - 10.0.1.0 is the starting IP
  # - /24 means we have 256 IP addresses
  # - Range: 10.0.1.0 to 10.0.1.255
  
  description = "CIDR block for first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# ==========================================
# Public Subnet 2 CIDR
# ==========================================
variable "public_subnet_2_cidr" {
  # Second subnet in a different range
  # 10.0.2.0/24 means:
  # - Range: 10.0.2.0 to 10.0.2.255
  # - This is separate from subnet 1
  
  description = "CIDR block for second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# ==========================================
# Availability Zones
# ==========================================
variable "availability_zones" {
  # Availability Zones = Different data centers
  # Think of them as different buildings in a city
  # If one building has power outage, others still work
  
  # eu-west-1a and eu-west-1b are in Ireland
  # They're physically separate locations
  
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
  
  # Why 2 zones? For high availability!
  # If eu-west-1a goes down, eu-west-1b keeps running
}

# ==========================================
# Instance Type
# ==========================================
variable "instance_type" {
  # Instance type = size of virtual computer
  # t2.micro = smallest size
  # - 1 CPU
  # - 1 GB RAM
  # - FREE TIER eligible!
  
  description = "EC2 instance type (size of virtual machine)"
  type        = string
  default     = "t3.micro"
}

# ==========================================
# AMI ID (Amazon Machine Image)
# ==========================================
variable "ami_id" {
  # AMI = Pre-built operating system image
  # This is Ubuntu 22.04 (free, popular, easy to use)
  # Think of it like a Windows installation disk
  # but for Linux in the cloud
  
  description = "AMI ID for EC2 instances (Ubuntu 22.04)"
  type        = string
  
  # This AMI is for eu-west-1 region
  # Different regions have different AMI IDs!
  default     = "ami-0d64bb532e0502c46"
}

# ==========================================
# Instance Count
# ==========================================
variable "instance_count" {
  # How many servers do we want?
  # 2 = minimum for load balancing
  # More = more high availability
  
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

# ==========================================
# Environment Tag
# ==========================================
variable "environment" {
  # Tag to identify what this is for
  # "learning" means it's for education, not production
  
  description = "Environment name (dev, staging, prod, learning)"
  type        = string
  default     = "learning"
}