###################
# General Variables
###################

variable "project_name" {
  type        = string
  description = "The name of the project"

}

###################
# Database Variables
###################
variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance class for the RDS instance"

  validation {
    condition     = contains(["db.t3.micro"], var.instance_class)
    error_message = "Only db.t3.micro is allowed due to free tier access"
  }

}

variable "storage" {
  type        = number
  default     = 10
  description = "The amount of storage in GB for the DB instance"

  validation {
    condition     = var.storage >= 5 && var.storage <= 10
    error_message = "DB storage must be between 5 and 10 GB"
  }
}


variable "engine" {
  type        = string
  default     = "postgres-latest"
  description = "The database engine to use"

  validation {
    condition     = contains(["postgres-latest", "postgress-14"], var.engine)
    error_message = "DB engine must be postgres-latest and postgress-14"
  }
}

###################
# DB Credentials
###################

variable "credentials" {
  type = object({
    username = string
    password = string
  })
  description = "DB credentials"

  sensitive = true

  validation {
    condition = (
      length(regexall("[a-zA-Z]+", var.credentials.password)) > 0 &&
      length(regexall("[0-9]+", var.credentials.password)) > 0 &&
      length(regexall("^[a-zA-Z0-9+_?-]{8,}$", var.credentials.password)) > 0
    )
    error_message = <<-EOT
    Password must comply with the following format:

    1. Contain at least 1 character
    2. Contain at least 1 digit
    3. Be at least 8 characters long
    4. Contain only the following characters: a-z, A-Z, 0-9, +, _, ?, -
    EOT
  }
}

###################
# DB Network
###################

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs to launch the RDS instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security group IDs to assign to the RDS instance"
}
