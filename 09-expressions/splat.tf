locals {
    //works only with list-like values
#   firstnames_from_splat = var.objects_list[*].firstname
  firstnames_from_splat = toset(var.objects_list)[*].firstname

#   roles_from_splat = [for username, user_props in local.users_map_2 : user_props]
    # roles_from_splat = values(local.users_map_2)[*].roles
    roles_from_splat = [for username, user_props in local.users_map_2 : user_props.roles]


}
output "firstnames_from_splat" {
  value = local.firstnames_from_splat
}

output "roles_from_splat" {
  value = local.roles_from_splat
}