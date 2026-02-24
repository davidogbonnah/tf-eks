# tf-eks

This module provisions an Amazon Elastic Kubernetes Service (EKS) cluster upon its supporting infrastructure, and alongside supporting resources such as IAM roles, node groups, and encryption keys. It is designed to integrate seamlessly with other Terraform modules, such as a VPC module.

---

## Requirements

The following requirements are needed by this module:

- **Terraform**: >= 1.11.0
- **AWS Provider**: 5.93.0

---

## Providers

The following providers are used by this module:

- **AWS**: 5.93.0
- **Terraform**: Latest

---

## Resources

This module provisions the following resources:

- **EKS Resources**:
  - [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/5.93.0/docs/resources/eks_cluster): Creates the EKS cluster.
  - [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/5.93.0/docs/resources/eks_node_group): Provisions managed node groups for the EKS cluster.
- **IAM Resources**:
  - [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/5.93.0/docs/resources/iam_role): Creates IAM roles for the EKS cluster and worker nodes.
  - [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.93.0/docs/resources/iam_role_policy_attachment): Attaches policies to IAM roles for cluster and node permissions.
- **KMS Resources**:
  - [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/5.93.0/docs/resources/kms_key): Creates a KMS key for encrypting EKS secrets.
- **Data Sources**:
  - [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state): Fetches outputs from the VPC module.

---

## Optional Inputs

The following input variables are optional and have default values:

- **`cluster_name`**: The name of the EKS cluster.  
  *Type*: `string`  
  *Default*: `"dco-vf-eks-cluster"`

- **`org_network_ip_range`**: The Organizational CIDR block range.  
  *Type*: `list(string)`  
  *Default*:  
  ```json
  [
    "123.123.123.123/32"
  ]
  ```

- **`region`**: The AWS region to deploy the resources in.  
  *Type*: `string`  
  *Default*: `"eu-west-2"`

---

## Outputs

The following outputs are exported:

- **`eks_cluster`**: Details of the provisioned EKS cluster.

---

## Usage

1. **Initialize Terraform**:
   ```sh
   terraform init
   ```

2. **Validate Configuration**:
   ```sh
   terraform validate
   ```

3. **Plan Deployment**:
   ```sh
   terraform plan
   ```

4. **Apply Changes**:
   ```sh
   terraform apply -auto-approve
   ```

---

## Prerequisites

- A VPC must already be provisioned. This module fetches VPC details using the `terraform_remote_state` data source.
- AWS CLI configured with appropriate credentials.
- Terraform v1.11.0 or later.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_role](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_node_policies](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.eks_kms_key](https://registry.terraform.io/providers/hashicorp/aws/6.26.0/docs/resources/kms_key) | resource |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of worker nodes in the EKS node group. | `number` | `3` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether to enable private access to the EKS cluster endpoint. This allows access to the cluster from within the VPC. | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether to enable public access to the EKS cluster endpoint. It is recommended to set this to false for security reasons, and use a VPN or Direct Connect for secure access. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name for the EKS cluster. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the EKS node group. | `string` | `"t3.small"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of worker nodes in the EKS node group. | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of worker nodes in the EKS node group. | `number` | `1` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | The name of the organization. This is used for tagging resources. | `string` | n/a | yes |
| <a name="input_org_owner_email"></a> [org\_owner\_email](#input\_org\_owner\_email) | The email address of the organization owner. This is used for tagging resources. | `string` | n/a | yes |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | The CIDR blocks that are allowed to access the EKS cluster's public endpoint. This should be set to the IP ranges of your organization for security purposes. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs for the EKS cluster to use. These should be private subnets created in the VPC Terraform configuration. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster"></a> [eks\_cluster](#output\_eks\_cluster) | n/a |
<!-- END_TF_DOCS -->