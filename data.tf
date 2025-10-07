data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name       = var.cluster_name == "NULL" ? var.cluster_name : var.cluster_name
  depends_on = [aws_eks_cluster.cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = var.cluster_name == "NULL" ? var.cluster_name : var.cluster_name
  depends_on = [aws_eks_cluster.cluster]
}

data "aws_iam_policy_document" "eks_assume" {
  statement {
    sid = "EKSAssume"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    sid = "EKSAssume"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "irsa_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }
    effect = "Allow"
    dynamic "condition" {
      for_each = var.irsa_oidc_scope_sa != null && var.irsa_oidc_scope_sa != "" ? [
        {
          test     = "StringLike"
          variable = "${aws_iam_openid_connect_provider.oidc.url}:sub"
          values   = ["system:serviceaccount:${var.irsa_namespace}:${var.irsa_oidc_scope_sa}"]
        }
        ] : [
        {
          test     = "StringEquals"
          variable = "${aws_iam_openid_connect_provider.oidc.url}:sub"
          values   = ["system:serviceaccount:${var.irsa_namespace}:${var.irsa_sa_name}"]
        }
      ]
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.oidc.url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}
