resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    api_host = data.aws_eks_cluster.cluster.endpoint
    mapRoles = <<YAML
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: ${aws_iam_role.nodegroup.arn}
  username: system:node:{{EC2PrivateDNSName}}
YAML
    mapUsers = local.k8s_admins
  }
}

resource "kubernetes_namespace" "irsa" {
  metadata {
    name = var.irsa_namespace
  }
  depends_on = [kubernetes_config_map.aws_auth]
}

resource "kubernetes_service_account" "irsa" {
  metadata {
    name      = var.irsa_sa_name
    namespace = var.irsa_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa.arn
    }
  }
  depends_on = [kubernetes_config_map.aws_auth]
}