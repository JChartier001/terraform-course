/*
{
username: string
roles: string[]
}[]

{
username => roles
}
*/

locals {
  //loading yaml file with user info
  users_from_yaml = yamldecode(file("${path.module}/user-roles.yaml")).users
  //creating a map with username as key and roles as value
  users_map = {
    for user_config in local.users_from_yaml : user_config.username => user_config.roles
  }

}

//create users
resource "aws_iam_user" "users" {
  for_each = toset(local.users_from_yaml[*].username)
  name     = each.value
}

//create login profile for users
resource "aws_iam_user_login_profile" "users" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 8

  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }

}

//do not do in real life
output "passwords" {
  value = {
    for user, user_login in aws_iam_user_login_profile.users : user => user_login.password
  }

}

output "users" {
  value = local.users_from_yaml
}
