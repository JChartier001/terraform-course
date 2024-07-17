
locals {
  allowed_instance_types = ["t2.micro", "t3.micro"]

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


resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.this.id

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  tags = {
    CostCenter = "12345"
  }

  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = contains(local.allowed_instance_types, var.instance_type)
      error_message = "Var invalid instance type"
    }
    //run after apply stage - will usually pass at plan phase as the info isn't available until after the resource is created
    postcondition {
      condition     = contains(local.allowed_instance_types, self.instance_type)
      error_message = "Self invalid instance type"
    }
  }
}

//will only warn and not stop the creation of the resource
check "cost_center_check" {
  assert {
    condition     = can(aws_instance.this.tags["CostCenter"] != "")
    error_message = "Cost center tag is required"
  }
}
