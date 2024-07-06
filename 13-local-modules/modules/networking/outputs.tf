# 1. VPC Id
# 2. Public Subnets Ids & availability zones
# 3. Private Subnets Ids & availability zones


locals {
  output_public_subnets = {
    for key in keys(local.public_subnets): key => {
      subnet_id = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }
  output_private_subnets ={
    for key in keys(local.private_subnets): key => {
      subnet_id = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  
  }
}

output "vpc_id" {
  description ="AWS VPC ID"
  value = aws_vpc.this.id
}

output "public_subnets" {
  description = "Public Subnets IDs and Availability Zones"
  value = local.output_public_subnets
}

output "private_subnets" {
  description = "Private Subnets IDs and Availability Zones"
  value = local.output_private_subnets
}