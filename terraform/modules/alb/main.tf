provider "aws" {
  region = var.region
}

# ------------------------------------------------------------------------
# Tag
# ------------------------------------------------------------------------
locals {
  common_tags = {
    CreatedBy = "Terraform"
    Group     = "${var.cluster_name}-group"
  }
}

# ------------------------------------------------------------------------
# VPC & Subnet 생성(생략)
# ------------------------------------------------------------------------
# # VPC 생성
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# # Public Subnet 생성
# resource "aws_subnet" "public" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-west-2a" # 원하는 AZ로 변경하세요
# }

# # Private Subnet 생성
# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-west-2a" # 원하는 AZ로 변경하세요
# }

# Internet Gateway 생성
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
# }

# # Route Table 생성
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# # Route Table Association (Public Subnet)
# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }

# ------------------------------------------------------------------------
# ALB 생성
# ------------------------------------------------------------------------
# ALB 생성
resource "aws_lb" "public_lb" {
  name               = "${var.cluster_name}-pub-alb"
  internal           = false     # 내부 접근 옵션/true: private-subnet, false: public-subnet
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = flatten([local.public_subnet_ids])     # At least two subnets in two different Availability Zones must be specified

  enable_deletion_protection = false  #삭제 보호 기능/true: 활성화, false: 비활성화

  tags = merge(local.common_tags,{
    Name = "${var.cluster_name}-pub-alb"
  })
}

# Target Group 생성
resource "aws_lb_target_group" "jenkins_tg" {
  name        = "${var.cluster_name}-jenkins-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags,{
    Name = "${var.cluster_name}-jenkins-tg"
  })
}

# Listener 생성
resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }

  tags = merge(local.common_tags,{
    Name = "${var.cluster_name}-jenkins-alb-listener"
  })
}


# Target Group Attachment
resource "aws_lb_target_group_attachment" "jenkins_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = var.jenkins_id
  port             = 8080
}
