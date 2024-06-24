variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type        = string
}

variable "alb_name" {
  description = "name for Loadbalancer Name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

