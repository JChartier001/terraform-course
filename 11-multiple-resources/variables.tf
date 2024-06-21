# variable "subnet_count" {
#   type    = number
#   default = 2
# }

variable "subnet_config" {
  type = map(object({
    cidr_block = string
  }))

  # Ensure that all cidr blocks are valid
  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is invalid. CIDR blocks must be in the format x.x.x.x/x"
  }
}

# variable "ec2_instance_count" {
#   type    = number
#   default = 1
# }

variable "ec2_instance_config_list" {
  type = list(object({
    instance_type = string
    ami           = string
    # volume_config = object({
    #   size = number
    #   type = string
    # })
  }))


  # 1. Ensure that only t2.micro is used
  # Map from the object to the instance type
  # Map from the instance_type to a boolean indicating wether the value equals t2.micro
  # Check whether the list of booleans contains only true values
  validation {
    condition = alltrue([for config in var.ec2_instance_config_list : contains(["t2.micro"], config.instance_type)])

    # condition     = alltrue([for config in var.ec2_instance_config_list : config.instance_type == "t2.micro"])
    error_message = "Only t2.micro instances are allowed"

  }

  //Ensure that only ubuntu and nginx are used
  validation {
    condition = alltrue([for config in var.ec2_instance_config_list : contains(["nginx", "ubuntu"], config.ami)])

    # condition     = alltrue([for config in var.ec2_instance_config_list : config.ami == "ubuntu"|| config.ami == "nginx"])
    error_message = "At least one of the provided \"ami\" value is not allowed. \nSupported \"ami\" values: \"ubuntu\", \"nginx\" "

  }
}

variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
    # subnet_index  = optional(number,0 )
    subnet_name = optional(string, "default")
  }))

  # Ensure that only t2.micro is used
  validation {
    condition = alltrue([
      //config with values
      for config in values(var.ec2_instance_config_map) : contains(["t2.micro"], config.instance_type)
    ])
    error_message = "Only t2.micro instances are allowed."
  }

  # Ensure that only ubuntu and nginx images are used.
  validation {
    condition = alltrue([
      //key and value in the map
      for key, config in var.ec2_instance_config_map : contains(["nginx", "ubuntu"], config.ami)
    ])
    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }


}