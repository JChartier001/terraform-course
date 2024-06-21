locals {
  //defining our roles and policies
  role_policies = {
    readonly = [
      "ReadOnlyAccess"
    ],
    admin = [
      "AdministratorAccess"
    ]
    auditor = [
      "SecurityAudit"
    ],
    developer = [
      "AmazonVPCFullAccess",
      "AmazonEC2FullAccess",
      "AmazonS3FullAccess",
      "AmazonRDSFullAccess"
    ]
  }



  //map policy to a list of objects and contains a single role and policy
  role_policies_list = flatten([
    for role, policies in local.role_policies : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])

    /*[
  {
  role = "developer,
  policy = "AmazonVPCFullAccess""},
  {
  role = "developer,
  policy = "AmazonEC2FullAccess""},
  {
  role = "developer,
  policy = "AmazonS3FullAccess""},
  {
  role = "developer,
  policy = "AmazonRDSFullAccess""},
  ]*/
}

data "aws_caller_identity" "current" {}

/* 1. We must iterate over exsising roles and create a different assume role policy for each
2. In each role policy, under identifies and only the users that have that specific role should be able to assume the role

*/

//creating the assume role policy for users and for only the roles they are assigned
data "aws_iam_policy_document" "assume_role_policy" {
  for_each = toset(keys(local.role_policies))
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)
      ]

    }
  }
}

//create roles
resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.role_policies))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.value].json
}

//loading policies for our data
data "aws_iam_policy" "managed_policies" {
  for_each = toset(local.role_policies_list[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

//attaching policies to roles
resource "aws_iam_role_policy_attachment" "role_policy_attachments" {
  count      = length(local.role_policies_list)
  role       = aws_iam_role.roles[local.role_policies_list[count.index].role].name
  policy_arn = data.aws_iam_policy.managed_policies[local.role_policies_list[count.index].policy].arn
}