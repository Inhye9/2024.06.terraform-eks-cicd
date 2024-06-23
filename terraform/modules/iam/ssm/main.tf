provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    CreatedBy = "Terraform"
    Group     = "${var.cluster_name}-group"
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.cluster_name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags,{
    Name = "${var.cluster_name}-ec2-ssm-role"
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "${var.cluster_name}-ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_ssm_role.name
}

output "ec2_ssm_instance_profile_role" {
  value = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}