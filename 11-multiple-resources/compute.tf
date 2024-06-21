locals {
  ami_ids = {
    ubuntu = data.aws_ami.ubuntu.id
    nginx  = data.aws_ami.nginx.id
  }
}
data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] //Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# resource "aws_instance" "from_count" {
#   count         = var.ec2_instance_count
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   //more ec2s than subnets
#   subnet_id = aws_subnet.main[count.index % length(aws_subnet.main)].id
#   //subnets and ec2s are equal
#   # subnet_id = aws_subnet.main[count.index].id
#   tags = {
#     Project = local.project
#     Name    = "${local.project}-${count.index}"
#   }
# }

resource "aws_instance" "from_list" {
  count         = length(var.ec2_instance_config_list)
  ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
  instance_type = var.ec2_instance_config_list[count.index].instance_type
  //more ec2s than subnets
  subnet_id = aws_subnet.main["default"].id
  //subnets and ec2s are equal
  # subnet_id = aws_subnet.main[count.index].id
  tags = {
    Project = local.project
    Name    = "${local.project}-${count.index}"
  }
}


resource "aws_instance" "from_map" {
  # each.key   => holds the key of each key-value pair in the map 
  # each.value => holds the value of each key-value pair in the map
  for_each      = var.ec2_instance_config_map
  ami           = local.ami_ids[each.value.ami]
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main[each.value.subnet_name].id

  tags = {
    Name    = "${local.project}-${each.key}"
    Project = local.project
  }
}


data "aws_ami" "nginx" {

  most_recent = true


  filter {
    name   = "name"
    values = ["bitnami-nginx-1.25.5-*-linux-debian-12-x86_64-hvm-ebs-nami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}