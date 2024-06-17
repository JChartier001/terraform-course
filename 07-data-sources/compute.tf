
data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] //Owner is Canonical
  provider = aws.us_east

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "ubuntu_ami_data" {
  value = data.aws_ami.ubuntu
}
# resource "aws_instance" "web" {
#   ami                         = ubuntu_ami_data.id
#   associate_public_ip_address = true
#   instance_type               = "t2.micro"

#   root_block_device {
#     delete_on_termination = true
#     volume_size           = 10
#     volume_type           = "gp3"
#   }

# }
# resource "aws_security_group" "public_http_traffic" {
#   description = "Allow HTTP inbound traffic on ports 443 and 80"
#   name        = "public_http_traffic"
#   vpc_id      = aws_vpc.main.id

# }

# resource "aws_vpc_security_group_ingress_rule" "http" {
#   security_group_id = aws_security_group.public_http_traffic.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   to_port           = 80
#   ip_protocol       = "tcp"
# }
# resource "aws_vpc_security_group_ingress_rule" "https" {
#   security_group_id = aws_security_group.public_http_traffic.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 443
#   to_port           = 443
#   ip_protocol       = "tcp"
# }