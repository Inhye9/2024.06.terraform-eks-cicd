# Security Group 생성
resource "aws_security_group" "alb_sg" {
   name        = "${var.cluster_name}-alb-sg"
  description   = "Security group for Load Balancer"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags,{
    Name = "${var.cluster_name}-alb-sg"
  })
}

output alb_security_id {
    value = aws_security_group.alb_sg.id
}