locals {
  users_map      = { for user in var.users : user.username => user.role }
  users_map_map  = { for user in var.users : user.username => { role = user.role } }
  users_map_list = { for user in var.users_duplicate : user.username => user.role... }

  users_map_2 = { for username, roles in local.users_map_list : username => { roles = roles } }

  usernames_from_map = [for username, roles in local.users_map : username]
}

output "users_map" {
  value = local.users_map
}

output "users_map_map" {
  value = local.users_map_map
}

output "users_map_list" {
  value = local.users_map_list
}

output "users_map_2" {
  value = local.users_map_2
}

output "user_to_output_roles" {
  value = local.users_map_2[var.user_to_output].roles
}

output "usernames_from_map" {
  value = local.usernames_from_map
}