#--OIDC Provider
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.oidc_thumbprints
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

#--Cluster Role
resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}_cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

#--Nodegroup Role
resource "aws_iam_role" "nodegroup" {
  name               = "${var.cluster_name}_nodegroup"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.nodegroup.name
}

#--IRSA
resource "aws_iam_role" "irsa" {
  name               = "${var.cluster_name}_${local.irsa_role_purpose}"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json
}

resource "aws_iam_role_policy_attachment" "irsa" {
  policy_arn = var.irsa_managed_policy_arn
  role       = aws_iam_role.irsa.name
}
