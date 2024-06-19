variable "ec2_instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"

  #    validation {
  #     condition     = startswith(var.ec2_instance_type, "t3")
  #     error_message = "Only supports t3 family"

  #   }
  # }

  # export TF_VAR_ec2_instance_type="t3.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
    error_message = "Only supports t2.micro and t3.micro instance types"

  }
}

# variable "ec2_volume_size" {
#   type        = number
#   description = "The size of the root volume in GB"
#   default     = 10
# }
# variable "ec2_volume_type" {
#   type        = string
#   description = "The type of volume to use for the root volume"
#   default     = "gp3"
# }

variable "ec2_volume_config" {
  type = object({
    size = number
    type = string
  })
  description = "The type and size for the root block volume for EC2 instances"

  default = {
    size = 10
    type = "gp3"
  }
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to apply to the EC2 instance"
  default = {

  }
}

variable "my_sensitive_value" {
  type        = string
  description = "A sensitive value that should not be printed in logs"
  sensitive   = true
}


# order of precedence:
# -var cli argument
# -prod.auto.tfvars
# -terraform.tfvars
# -TF_VAR environment variable