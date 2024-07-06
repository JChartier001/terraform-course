module "networking" {
  source = "./modules/networking"
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "13-local-modules"
  }

  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-2a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      #Public subnets are indicated by setting the "public" attribute to true
      public     = true
      az         = "us-east-2b"
    }
  }
}