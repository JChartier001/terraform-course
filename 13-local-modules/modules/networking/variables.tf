

variable "vpc_config" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The variable vpc_config.cidr_block must be a valid CIDR block."
  }
}

//map allows multiple subnets to be created
variable "subnet_config" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = optional(bool, false)
  }))


  validation {
    condition = alltrue([
    for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))])

    error_message = "The variable subnet_config.cidr_block must be a valid CIDR block."
  }

}