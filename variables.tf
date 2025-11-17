variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "cluster1"
}

variable "k8s_version" {
  description = "Kubernetes Version"
  type        = string
  default     = "1.33"
}

variable "private_subnet_ids" {
  description = "List of AWS Private Subnet IDs to host k8s Control Plane and Nodes"
  type        = list(string)
}

variable "k8s_api_public_access_cidrs" {
  description = "List of Private Subnet CIDRs allowed to access k8s API"
  type        = list(string)
}

variable "k8s_admin_user_arns" {
  description = "List of ARNs for users who should have access to k8s API as admins"
  type        = list(string)
}

variable "oidc_thumbprints" {
  description = "All OIDC Provider CA Thumbprints"
  type        = list(string)
  default     = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"] #--AWS Starfield Root CA
}

variable "ng_instance_types" {
  description = "Instance Type for nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "ng_desired_size" {
  description = "Nodegroup Desired Size"
  type        = string
  default     = "1"
}

variable "ng_max_size" {
  description = "Nodegroup Max Size"
  type        = string
  default     = "2"
}

variable "ng_min_size" {
  description = "Nodegroup Minimum Size"
  type        = string
  default     = "1"
}

variable "custom_ng_policy" {
  description = "Custom IAM policy JSON to attach to node group"
  type        = string
  default     = ""
}

variable "enabled_log_types" {
  description = "List of Enabled Log Types"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_days" {
  description = "Log Retention Days"
  type        = string
  default     = "1"
}

variable "irsa_namespace" {
  description = "Namespace to be created for IRSA integration"
  type        = string
}

variable "irsa_role_purpose" {
  description = "IRSA Role Purpose"
  type        = string
  default     = "irsa"
}

variable "irsa_managed_policy_arn" {
  description = "ARN of managed IAM policy to attach to IRSA role"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "irsa_sa_name" {
  description = "Kubernetes IRSA Service Account Name"
  type        = string
  default     = "irsa-sa"
}

variable "irsa_oidc_scope_sa" {
  description = "Custom Kubernetes Service Account to be included in the IRSA sub claim. Can include a wildcard. Advanced use only"
  type        = string
  default     = ""
}
