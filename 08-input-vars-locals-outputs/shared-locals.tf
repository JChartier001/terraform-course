locals {
  project = "08-input-vars-locals-outputs"
  project_owner     = "terraform-course"
  cost_center       = "1234"
  ManagedBy         = "Terraform"
}
locals {
  common_tags = {
    project     = local.project
    owner       = local.project_owner
    cost_center = local.cost_center
    managed_by  = local.ManagedBy
    sensitive   = var.my_sensitive_value
  }
}
