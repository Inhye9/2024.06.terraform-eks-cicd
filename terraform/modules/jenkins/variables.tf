variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "cluster_name" {
  description = "name for EKS Cluster"
  type        = string
}

variable "jenkins_name" {
  description = "name for EC2 instance"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_profile_role" {
  description = "instance_profile_name"
  type        = string
}

variable "alb_security_id" {
  description = "load balancer security id"
  type        = string
}
