data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"]
}

resource "aws_instance" "web_servers" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  subnet_id = element(
    [aws_subnet.public_1.id, aws_subnet.public_2.id],
    count.index % 2
  )
  
  vpc_security_group_ids = [aws_security_group.web_servers.id]
  
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {}))
  
  user_data_replace_on_change = true
  
  tags = {
    Name = "${var.project_name}-web-server-${count.index + 1}"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}