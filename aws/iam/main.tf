locals {
  system       = "linux"
  github_owner = "kohei3110"
  github_repo  = "Multi-Cloud-Management"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sigstore"]
  thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}

resource "aws_iam_role" "github_actions" {
  name = "${local.system}-github-actions"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.github_actions.id}"
      },
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:${local.github_owner}/${local.github_repo}:*"
        }
      },
      "Action": "sts:AssumeRoleWithWebIdentity"
    }
  ]
}
EOF
}