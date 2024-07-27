locals {
  db_endgine = {
    postgres-latest = {
      engine  = "postgres",
      version = "16.1",
      family  = "postgres16",
    }
    postrgres14 = {
      engine  = "postgres",
      version = "14.11",
      family  = "postgres14",
    }
  }
}


resource "aws_db_subnet_group" "this" {
  name       = var.project_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.project_name
  }
}

resource "aws_db_parameter_group" "this" {
  name   = var.project_name
  family = local.db_endgine[var.engine].family

  parameter {
    name  = "log_connections"
    value = "1"
  }

}

resource "aws_db_instance" "this" {
  identifier           = var.project_name
  instance_class       = var.instance_class
  allocated_storage    = var.storage
  engine               = local.db_endgine[var.engine].engine
  username             = var.credentials.username
  password             = var.credentials.password
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false
  skip_final_snapshot  = true
}
