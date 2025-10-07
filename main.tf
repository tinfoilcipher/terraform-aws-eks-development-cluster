resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = var.enabled_log_types
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.k8s_version
  vpc_config {
    subnet_ids             = var.private_subnet_ids
    endpoint_public_access = true
    public_access_cidrs    = var.k8s_api_public_access_cidrs
  }
}

resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.cluster.name
  version         = var.k8s_version
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.ng_instance_types
  scaling_config {
    desired_size = var.ng_desired_size
    max_size     = var.ng_max_size
    min_size     = var.ng_min_size
  }
  depends_on = [
    kubernetes_config_map.aws_auth,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchFullAccess,
  ]
}
