# Terraform Module - EKS Development Cluster

A terraform module to create an EKS development cluster with associated IAM components. Includes an IRSA integration and namespace creation.

Often we need to test and debug things and a local Kubernetes environment is up to the task. This module aims to provide a simple, temporary development environment with the IAM integration to AWS services taken care of.

This module creates:

- An EKS cluster on private VPC subnets with a **PUBLIC FACING** API, controlled by an IP ACL
- A single managed node group, with scaling and compute size options
- A managed list of admin users (added to the Kubernetes *master* group), made up of existing AWS IAM Users
- Cloudwatch logging for the cluster
- A Kubernetes namespace
- An IRSA configuration to allow application deployments from your namespace. By default this creates a Service Account named **irsa-sa** within your namespace which can access AWS AdministratorAccess permissions. This can be customised.

This design is not especially hardened, with the only real protections being an IP ACL and your user's ability to authenticate. Users are given admin access with no means to change this. This is not intended as a production or even pre-production solution. For development and debugging purposes only.

See [examples](./examples/) for configuration options.

## Usage

```bash
terraform init
terraform apply
aws eks update-kubeconfig --region $REGION_CODE --name $CLUSTER_NAME #--Enter your region and cluster name
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.nodegroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.CloudWatchFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_namespace.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.ec2_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.irsa_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | `"cluster1"` | no |
| <a name="input_enabled_log_types"></a> [enabled\_log\_types](#input\_enabled\_log\_types) | List of Enabled Log Types | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_irsa_managed_policy_arn"></a> [irsa\_managed\_policy\_arn](#input\_irsa\_managed\_policy\_arn) | ARN of managed IAM policy to attach to IRSA role | `string` | `"arn:aws:iam::aws:policy/AdministratorAccess"` | no |
| <a name="input_irsa_namespace"></a> [irsa\_namespace](#input\_irsa\_namespace) | Namespace to be created for IRSA integration | `string` | n/a | yes |
| <a name="input_irsa_oidc_scope_sa"></a> [irsa\_oidc\_scope\_sa](#input\_irsa\_oidc\_scope\_sa) | Custom Kubernetes Service Account to be included in the IRSA sub claim. Can include a wildcard. Advanced use only | `string` | `""` | no |
| <a name="input_irsa_role_purpose"></a> [irsa\_role\_purpose](#input\_irsa\_role\_purpose) | IRSA Role Purpose | `string` | `"irsa"` | no |
| <a name="input_irsa_sa_name"></a> [irsa\_sa\_name](#input\_irsa\_sa\_name) | Kubernetes IRSA Service Account Name | `string` | `"irsa-sa"` | no |
| <a name="input_k8s_admin_user_arns"></a> [k8s\_admin\_user\_arns](#input\_k8s\_admin\_user\_arns) | List of ARNs for users who should have access to k8s API as admins | `list(string)` | n/a | yes |
| <a name="input_k8s_api_public_access_cidrs"></a> [k8s\_api\_public\_access\_cidrs](#input\_k8s\_api\_public\_access\_cidrs) | List of Private Subnet CIDRs allowed to access k8s API | `list(string)` | n/a | yes |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Kubernetes Version | `string` | `"1.33"` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log Retention Days | `string` | `"1"` | no |
| <a name="input_ng_desired_size"></a> [ng\_desired\_size](#input\_ng\_desired\_size) | Nodegroup Desired Size | `string` | `"1"` | no |
| <a name="input_ng_instance_types"></a> [ng\_instance\_types](#input\_ng\_instance\_types) | Instance Type for nodes | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_ng_max_size"></a> [ng\_max\_size](#input\_ng\_max\_size) | Nodegroup Max Size | `string` | `"2"` | no |
| <a name="input_ng_min_size"></a> [ng\_min\_size](#input\_ng\_min\_size) | Nodegroup Minimum Size | `string` | `"1"` | no |
| <a name="input_oidc_thumbprints"></a> [oidc\_thumbprints](#input\_oidc\_thumbprints) | All OIDC Provider CA Thumbprints | `list(string)` | <pre>[<br/>  "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"<br/>]</pre> | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of AWS Private Subnet IDs to host k8s Control Plane and Nodes. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->