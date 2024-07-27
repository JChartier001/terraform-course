import {
  to = aws_iam_openid_connect_provider.terraform_cloud
  id = "arn:aws:iam::891376936920:oidc-provider/app.terraform.io/"
}

import {
  to = aws_iam_role.terraform_cloud_admin
  id = "terraform-cloud-automation-admin"
}

import {
  to = aws_iam_role_policy_attachment.terraform_cloud_admin
  id = "terraform-cloud-automation-admin/arn:aws:iam::aws:policy/AdministratorAccess"
  #   "${aws_iam_role.terraform_cloud_admin.name}/${data.aws_iam_policy.admin.arn}"
}



resource "aws_iam_openid_connect_provider" "terraform_cloud" {
  url             = "https://${var.terraform_cloud_hostname}"
  client_id_list  = ["aws.workload.identity"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]


  tags = {
    Name = "Terraform Cloud"
  }
}

data "aws_iam_policy_document" "terraform_cloud_admin_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.terraform_cloud.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.terraform_cloud_hostname}:aud"
      values   = [var.terraform_cloud_audience]
    }

    condition {
      test     = "StringLike"
      variable = "${var.terraform_cloud_hostname}:sub"
      values = [for workspace in var.admin_role_workspaces :
        "organization:Farm2Table:project:${var.admin_role_project}:workspace:${workspace}:run_phase:*"
      ]
    }
  }
}

resource "aws_iam_role" "terraform_cloud_admin" {
  name               = "terraform-cloud-automation-admin"
  assume_role_policy = data.aws_iam_policy_document.terraform_cloud_admin_assume_policy.json
}

data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "terraform_cloud_admin" {
  role       = aws_iam_role.terraform_cloud_admin.name
  policy_arn = data.aws_iam_policy.admin.arn
}
