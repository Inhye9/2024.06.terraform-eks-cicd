variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "name for EKS Cluster"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "jenkins_id" {
  description = "Jenkins EC2 ID"
  type        = string
}

