provider "aws" {
  region = var.region
}

# ------------------------------------------------------------------------
#  IAM 생성 
# ------------------------------------------------------------------------ 
module "ec2-ssm-role" {
  source = "../../modules/iam/ssm"
  region              = var.region
  cluster_name			  = var.cluster_name
}

# ------------------------------------------------------------------------
#  Nexus EC2 생성 
# ------------------------------------------------------------------------ 
module "nexus" {
  source = "../../modules/ec2"
  region                          = var.region
  vpc_id                          = var.vpc_id
  subnet_id                       = "subnet-05d7355ea9225be26"  #ih-private-subnet-a
  instance_name                   = "eks-blue-nexus"
  key_pair_name                   = var.key_pair_name 
  instance_type                   = "t3.xlarge"
  instance_profile_role           = module.ec2-ssm-role.ec2_ssm_instance_profile_role
  load_balancer_arn               = module.alb.load_balancer_arn
  alb_listener_port               = "8081"
  alb_listener_instance_port      = "8081"
}

# ------------------------------------------------------------------------
#  Jenkins EC2 생성 
# ------------------------------------------------------------------------ 
module "jenkins" {
  source = "../../modules/ec2"
  region                          = var.region
  vpc_id                          = var.vpc_id
  subnet_id                       = "subnet-05d7355ea9225be26"  #ih-private-subnet-a
  instance_name                   = "eks-blue-jenkins"
  key_pair_name                   = var.key_pair_name 
  instance_type                   = "t3.micro"
  instance_profile_role           = module.ec2-ssm-role.ec2_ssm_instance_profile_role
  load_balancer_arn               = module.alb.load_balancer_arn
  alb_listener_port               = "80"
  alb_listener_instance_port      = "8080"
}
# ------------------------------------------------------------------------
#  LoadBalancer 생성 
# ----------------------------------------------------------------------- 
module "alb" {
  source = "../../modules/alb"
  region                          = var.region
  vpc_id                          = var.vpc_id
  alb_name			                  = "eks-blue"
  subnet_id                       = "subnet-012bc0bc3effda7d9"  #ih-public-subnet-a
}
