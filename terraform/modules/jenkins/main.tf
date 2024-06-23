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


# EC2 인스턴스 생성
resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id
  #security_groups_ids = [aws_security_group.jenkins_sg.id]
  vpc_security_group_ids  = [aws_security_group.jenkins_sg.id]
  iam_instance_profile  = var.instance_profile_role
  user_data                   = file("../../modules/jenkins/docker-compose.sh")

  # public ip 할당 허용
  associate_public_ip_address = true

  tags = merge(local.common_tags,{
    Name = "${var.jenkins_name}"
  })
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-id"
    values = ["137112412989"] # Amazon
  }
}


output jenkins_ec2_id {
  value = aws_instance.jenkins.id
}