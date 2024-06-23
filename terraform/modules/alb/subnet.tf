# 특정 VPC에 속한 모든 서브넷 가져오기
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# 각 서브넷의 상세 정보를 가져와서 Public Subnet 필터링
data "aws_subnet" "public_subnets" {
  count = length(data.aws_subnets.vpc_subnets.ids)
  id    = data.aws_subnets.vpc_subnets.ids[count.index]
}

# Public Subnet을 필터링하는 로컬 변수
locals {
  public_subnet_ids = [
    for subnet in data.aws_subnet.public_subnets :
    subnet.id
    if subnet.map_public_ip_on_launch  # public ip 자동 할당 여부
  ]
}

# 결과 출력
output "public_subnet_ids" {
  value = local.public_subnet_ids
}
