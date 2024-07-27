output "rds_endpoint" {
  value = module.database.rds_instance_endpoint
}

output "rds_address" {
  value = module.database.rds_instance_address
}
