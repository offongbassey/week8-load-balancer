resource "aws_lb" "main" {
  name                       = "${var.project_name}-alb"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer.id]
  subnets                    = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  enable_deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "web_servers" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = false
  }
  
  deregistration_delay = 30
  
  tags = {
    Name = "${var.project_name}-target-group"
  }
}

resource "aws_lb_target_group_attachment" "web_servers" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.web_servers.arn
  target_id        = aws_instance.web_servers[count.index].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
  
  tags = {
    Name = "${var.project_name}-http-listener"
  }
}