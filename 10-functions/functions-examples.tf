locals {
  name = "Jen Chartier"
  age  = 46
  my_object = {
    key1 = 10
    key2 = "value2"
  }
  #   age  = -46
}

output "example" {

  # value = upper(local.name)
  value = startswith(lower(local.name), "jen")
}

output "example2" {
  #   value = local.age * 2
  # value = abs(local.age)
  value = pow(local.age, 2)
}

output "example_3" {
  # value = file("${path.module}/users.yaml")
  value = yamldecode(file("${path.module}/users.yaml")).users
}

output "example_4" {
  # value = yamlencode(local.my_object)
  value = jsonencode(local.my_object)
}