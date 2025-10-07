module "eks_development" {
  source       = "tinfoilcipher/eks-development-cluster/aws"
  version      = "x.x.x"
  cluster_name = "tinfoilcluster"
  private_subnet_ids = [
    "subnet-01234567891234567",
    "subnet-abcdef12341234567",
    "subnet-01234567890abcdef"
  ]
  k8s_api_public_access_cidrs = [
    "85.1.12.1/32",    #--Include your own public IP
    "13.12.155.235/32" #--Include your NAT Gateway EIP in you have no other fancy routing. Nodes need to be able to reach the k8s API
  ]
  k8s_admin_user_arns = [
    "arn:aws:iam::123456789012:user/andy.welsh", #--Users will be added to the kubernetes "masters" group, with full admin rights
    "arn:aws:iam::123456789012:user/someone.else"
  ]
}
