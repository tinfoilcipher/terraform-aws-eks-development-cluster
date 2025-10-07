module "eks_development" {
  source             = "tinfoilcipher/eks-development-cluster/aws"
  version            = "x.x.x"
  cluster_name       = "tinfoilcluster"
  k8s_version        = "1.33"
  ng_instance_types  = ["m5.xlarge"]
  ng_desired_size    = "2"
  ng_max_size        = "3"
  ng_min_size        = "1"
  enabled_log_types  = ["api", "scheduler"] #--Select a subset of logs if needed
  log_retention_days = "14"
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
  irsa_namespace     = "my-application" #--This namespace is created and IRSA permissions associated
  irsa_role_purpose  = "myapplication"  #--This name is given to the IRSA role
  irsa_sa_name       = "my-application"
  irsa_oidc_scope_sa = "my-app*" #--This custom pattern is added to the IRSA role's OIDC sub claim.
}                                #--This allows a broad scope of sources for OIDC requests. If unset, requests can come from the named service account above only. Change only for advanced cases
