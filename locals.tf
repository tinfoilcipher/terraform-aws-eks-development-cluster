locals {
  k8s_admin_user_arns = flatten([
    for userarn in var.k8s_admin_user_arns : {
      userarn  = userarn
      username = trimprefix(userarn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/")
      groups   = ["system:masters"]
    }
  ])
  k8s_admins        = yamlencode(local.k8s_admin_user_arns)
  irsa_role_purpose = lower(var.irsa_role_purpose)
}
