variable "ec2_instance_type" {
  type = string
  validation {
    condition     = var.ec2_instance_type == "t2.micro"
    error_message = "Only t2.micro is allowed"
  }

}
