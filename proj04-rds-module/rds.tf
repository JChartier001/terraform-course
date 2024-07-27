module "database" {
  source = "./modules/rds"

  subnet_ids         = [aws_subnet.private1.id, aws_subnet.private2.id]
  security_group_ids = [aws_security_group.compliant.id]

  project_name = "proj04-rds-module"
  credentials = {
    username = "dbadmin"
    password = "1234abc+d"
  }

}
