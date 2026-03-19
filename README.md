# Week 8: High-Availability Web Application with AWS Load Balancer

## 📋 Project Overview

This project demonstrates a production-grade high-availability web architecture using AWS Application Load Balancer, EC2 instances, and Infrastructure as Code with Terraform.

**Status:** ✅ Complete - Deployed and Tested

---

## 🏗️ Architecture
```
                    INTERNET
                       ↓
              [Application Load Balancer]
                       ↓
        ┌──────────────┴──────────────┐
        ↓                              ↓
   [EC2 Web Server 1]          [EC2 Web Server 2]
   eu-west-1a                  eu-west-1b
   10.0.1.x                    10.0.2.x
```
## 🌐 Live Demo

**Load Balancer URL:** `http://[your-actual-url].elb.amazonaws.com`

> Replace with your actual URL from terraform outputs

**Test it:**
- Visit the URL in your browser
- Refresh multiple times to see different servers respond
- Each refresh may show a different instance ID


**Key Features:**
- ✅ High availability across 2 availability zones
- ✅ Automated health checks
- ✅ Load balancing with round-robin distribution
- ✅ Auto-healing (unhealthy instances removed)
- ✅ Zero-downtime deployments

---

## 🛠️ Technologies Used

| Technology | Purpose |
|-----------|---------|
| **AWS EC2** | Virtual servers hosting web applications |
| **AWS ALB** | Application Load Balancer for traffic distribution |
| **AWS VPC** | Virtual Private Cloud for network isolation |
| **Terraform** | Infrastructure as Code automation |
| **Ubuntu 22.04** | Operating system for EC2 instances |
| **Apache** | Web server software |
| **Bash** | Server configuration scripting |

---

## 📊 Infrastructure Components

### Network Layer:
- **VPC:** 10.0.0.0/16 (65,536 IP addresses)
- **Public Subnet 1:** 10.0.1.0/24 in eu-west-1a
- **Public Subnet 2:** 10.0.2.0/24 in eu-west-1b
- **Internet Gateway:** Public internet access
- **Route Tables:** Traffic routing configuration
- **Security Groups:** Firewall rules

### Compute Layer:
- **2 x t3.micro instances** (1 vCPU, 1GB RAM each)
- **Ubuntu 22.04 LTS** operating system
- **Apache web server** with custom pages
- **User data scripts** for automated setup

### Load Balancing:
- **Application Load Balancer** (Layer 7)
- **Target Group** with health checks
- **HTTP Listener** on port 80
- **Health checks** every 30 seconds

---

## 🚀 Deployment Instructions

### Prerequisites:
- AWS account
- Terraform installed
- AWS CLI configured
- Git installed

### Deploy:
```bash
# Clone repository
git clone https://github.com/offongbassey/week8-load-balancer.git
cd week8-load-balancer

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy infrastructure
terraform apply
# Type 'yes' when prompted

# Get load balancer URL
terraform output website_url
```

---

## 🧪 Testing

### Test Load Balancing:
1. Visit the load balancer URL from outputs
2. Refresh the page multiple times
3. Observe instance ID changing (different servers responding)

### Test High Availability:
1. Stop one EC2 instance in AWS Console
2. Wait 60 seconds for health checks
3. Refresh load balancer URL
4. Website still works! (traffic goes to healthy instance)

### Test Auto-Healing:
1. SSH into one instance
2. Stop Apache: `sudo systemctl stop apache2`
3. Wait for health checks to fail
4. Load balancer stops sending traffic to that instance


**Planned screenshots:**
1. Terraform apply success
2. AWS EC2 instances running
3. Load balancer configuration
4. Target group health checks
5. Website showing different servers
6. High availability test results

## 📸 Screenshots

### 1. Terraform Deployment

**Terraform Init & Apply:**

![Terraform Init](screenshots/Week%208%20Screenshots/01-terraform-init.png)

*Screenshot showing: `terraform init` command completing successfully with provider downloads*

---

![Terraform Plan](screenshots/Week%208%20Screenshots/02-terraform-plan.png)

*Screenshot showing: `terraform plan` output with resources to be created*

---

![Terraform Apply Success](screenshots/Week%208%20Screenshots/03-terraform-apply-success.png)

*Screenshot showing: `terraform apply` completion with "Apply complete! Resources: XX added"*

---

![Terraform Outputs](screenshots/Week%208%20Screenshots/04-terraform-outputs.png)

*Screenshot showing: Load balancer URL and other outputs displayed*

---

### 2. AWS Infrastructure

**EC2 Instances Running:**

![EC2 Instances](screenshots/Week%208%20Screenshots/05-ec2-instances.png)

*Screenshot showing: Both EC2 instances running in different availability zones*

---

**Application Load Balancer:**

![Load Balancer](screenshots/Week%208%20Screenshots/06-load-balancer.png)

*Screenshot showing: ALB in active state with DNS name visible*

---

**Target Group with Health Checks:**

![Target Group Healthy](screenshots/Week%208%20Screenshots/07-target-group-healthy.png)

*Screenshot showing: Both targets healthy with green checkmarks*

---

### 3. Website Testing

**Server 1 Response:**

![Website Server 1](screenshots/Week%208%20Screenshots/08-website-server-1.png)

*Screenshot showing: Website displaying Server 1 information (instance ID, zone, IP)*

---

**Server 2 Response:**

![Website Server 2](screenshots/Week%208%20Screenshots/09-website-server-2.png)

*Screenshot showing: Website displaying Server 2 information (different instance ID)*

---

### 4. High Availability Testing

**Stopping One Instance:**

![Stop Instance](screenshots/Week%208%20Screenshots/10-stop-instance.png)

*Screenshot showing: Stopping one EC2 instance in AWS Console*

---

**Target Group After Failure:**

![Target Unhealthy](screenshots/Week%208%20Screenshots/11-target-unhealthy.png)

*Screenshot showing: One target unhealthy (red), one healthy (green)*

---

**Website Still Working:**

![Website Still Working](screenshots/Week%208%20Screenshots/12-website-still-working.png)

*Screenshot showing: Website still accessible despite one server down*

---

### 5. Infrastructure Details

**VPC Configuration:**

![VPC Details](screenshots/Week%208%20Screenshots/13-vpc-details.png)

*Screenshot showing: VPC with subnets in different availability zones*

---

**Security Groups:**

![Security Groups](screenshots/Week%208%20Screenshots/14-security-groups.png)

*Screenshot showing: Security group rules for web servers and load balancer*

---

---

## 💰 Cost Estimate

**Monthly cost:** ~$0 (Free tier eligible)

- t3.micro instances: Free tier (750 hours/month)
- Application Load Balancer: Free tier (750 hours/month)
- Data transfer: Free tier (1GB/month)

**Note:** Costs may apply if exceeding free tier limits.

---

## 🧹 Cleanup
```bash
# Destroy all resources
terraform destroy
# Type 'yes' when prompted

# Verify deletion in AWS Console
```

**Estimated time:** 3-5 minutes

---

## 📚 Learning Outcomes

**Skills Demonstrated:**
- ✅ AWS VPC and subnet configuration
- ✅ Application Load Balancer setup
- ✅ EC2 instance management
- ✅ Security group configuration
- ✅ Health check implementation
- ✅ High availability architecture
- ✅ Infrastructure as Code with Terraform
- ✅ Bash scripting for automation

**Concepts Learned:**
- Load balancing algorithms
- Health check mechanisms
- Availability zones and regions
- CIDR notation and subnetting
- Target groups and listeners
- Security group rules
- User data scripts

---

## 🔧 Troubleshooting

### Common Issues:

**Issue:** Health checks failing
- **Solution:** Check security group allows traffic on port 80

**Issue:** Can't access load balancer URL
- **Solution:** Wait 2-3 minutes for instances to become healthy

**Issue:** terraform apply fails
- **Solution:** Check AWS credentials are configured

---

## 👨‍💻 Author

**Offong Bassey**
- GitHub: [@offongbassey](https://github.com/offongbassey)
- Project: Part of 12-Week Cloud Computing Challenge
- Week: 8 of 12

---

## 📄 License

This project is for educational purposes.

---

**Last Updated:** March 2026