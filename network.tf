# ==========================================
# NETWORK INFRASTRUCTURE
# ==========================================
# This file creates the network foundation
# Think of it as building roads and infrastructure
# before building houses

# ==========================================
# VPC - Virtual Private Cloud
# ==========================================
# VPC = Your own private network in AWS
# Like having your own private internet
# No one else can access it unless you allow them

resource "aws_vpc" "main" {
  # CIDR block = range of IP addresses for this VPC
  # Using our variable from variables.tf
  cidr_block = var.vpc_cidr
  
  # Enable DNS hostnames
  # This means each EC2 instance gets a hostname
  # Like "server1.internal" instead of just IP address
  enable_dns_hostnames = true
  
  # Enable DNS support
  # This lets instances resolve domain names
  # Like translating "google.com" to an IP address
  enable_dns_support   = true
  
  # Tags = labels to identify resources
  # Helpful when you have many resources
  tags = {
    Name        = "${var.project_name}-vpc"
    # Example result: "week8-lb-vpc"
    Environment = var.environment
    # Example result: "learning"
  }
}

# ==========================================
# Internet Gateway
# ==========================================
# Internet Gateway = door to the internet
# Without this, your VPC is isolated
# With this, resources can reach the internet

resource "aws_internet_gateway" "main" {
  # Which VPC does this gateway belong to?
  # We reference the VPC we created above
  vpc_id = aws_vpc.main.id
  
  # Tags for identification
  tags = {
    Name        = "${var.project_name}-igw"
    # Example: "week8-lb-igw"
    Environment = var.environment
  }
}

# ==========================================
# Public Subnet 1 (Availability Zone A)
# ==========================================
# Subnet = subdivision of VPC
# Public = can reach internet (has route to IGW)
# AZ A = Availability Zone A (one data center)

resource "aws_subnet" "public_1" {
  # Which VPC does this subnet belong to?
  vpc_id = aws_vpc.main.id
  
  # IP address range for this subnet
  # 10.0.1.0/24 = 256 addresses
  cidr_block = var.public_subnet_1_cidr
  
  # Which availability zone?
  # eu-west-1a = first zone in Ireland region
  availability_zone = var.availability_zones[0]
  # [0] means first item in the list
  
  # Auto-assign public IP
  # When EC2 launches here, it gets public IP automatically
  # This lets it be accessed from internet
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.project_name}-public-subnet-1"
    Environment = var.environment
    Type        = "Public"
  }
}

# ==========================================
# Public Subnet 2 (Availability Zone B)
# ==========================================
# Second subnet in different availability zone
# Why? High availability!
# If AZ A goes down, AZ B keeps running

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  
  # Different availability zone
  # eu-west-1b = second zone in Ireland
  availability_zone = var.availability_zones[1]
  # [1] means second item in the list
  
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.project_name}-public-subnet-2"
    Environment = var.environment
    Type        = "Public"
  }
}

# ==========================================
# Route Table
# ==========================================
# Route Table = directions for traffic
# Like a GPS telling traffic where to go
# "Want to reach internet? Go through the IGW!"

resource "aws_route_table" "public" {
  # Which VPC does this route table belong to?
  vpc_id = aws_vpc.main.id
  
  # Route = a single direction rule
  route {
    # Destination: 0.0.0.0/0
    # This means "anywhere on the internet"
    # /0 = all IP addresses
    cidr_block = "0.0.0.0/0"
    
    # Target: Internet Gateway
    # "To reach internet, go through this gateway"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# ==========================================
# Route Table Association - Subnet 1
# ==========================================
# Associate = connect route table to subnet
# This tells Subnet 1: "Use this route table for directions"

resource "aws_route_table_association" "public_1" {
  # Which subnet?
  subnet_id = aws_subnet.public_1.id
  
  # Which route table?
  route_table_id = aws_route_table.public.id
  
  # Now Subnet 1 knows how to reach internet!
}

# ==========================================
# Route Table Association - Subnet 2
# ==========================================
# Same thing for Subnet 2

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ==========================================
# Security Group for Web Servers
# ==========================================
# Security Group = firewall rules
# Controls what traffic can enter/exit
# Like a bouncer at a club - checks who gets in

resource "aws_security_group" "web_servers" {
  # Name and description
  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  
  # Which VPC?
  vpc_id = aws_vpc.main.id
  
  # INGRESS = incoming traffic rules
  # What traffic is ALLOWED IN?
  
  # Rule 1: Allow HTTP (web traffic)
  ingress {
    # Description helps us remember what this is for
    description = "Allow HTTP from anywhere"
    
    # from_port and to_port = port range
    # 80 = HTTP port (websites)
    from_port   = 80
    to_port     = 80
    
    # protocol = type of traffic
    # tcp = Transmission Control Protocol (most common)
    protocol    = "tcp"
    
    # cidr_blocks = who can access?
    # 0.0.0.0/0 = anyone on the internet
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Rule 2: Allow SSH (remote access)
  ingress {
    description = "Allow SSH from anywhere"
    
    # Port 22 = SSH (Secure Shell)
    # Used to remotely connect to server
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
    # WARNING: In production, you'd restrict this!
    # For learning, we allow from anywhere
  }
  
  # EGRESS = outgoing traffic rules
  # What traffic is ALLOWED OUT?
  
  # Rule: Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    
    # 0 = all ports
    from_port   = 0
    to_port     = 0
    
    # -1 = all protocols (tcp, udp, icmp, etc.)
    protocol    = "-1"
    
    # 0.0.0.0/0 = to anywhere on internet
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = var.environment
  }
}

# ==========================================
# Security Group for Load Balancer
# ==========================================
# Separate security group for the load balancer
# Different rules because it has different needs

resource "aws_security_group" "load_balancer" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id
  
  # Allow HTTP from internet
  # Load balancer needs to receive traffic from users
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound
  # Load balancer needs to forward traffic to servers
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.project_name}-lb-sg"
    Environment = var.environment
  }
}