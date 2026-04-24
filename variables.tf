variable "environment" {
  description = "The environment name for the EKS cluster."
  type        = string
}

variable "org_name" {
  description = "The name of the organization. This is used for tagging resources."
  type        = string
}

variable "org_owner_email" {
  description = "The email address of the organization owner. This is used for tagging resources."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster to use. These should be private subnets created in the VPC Terraform configuration."
  type        = list(string)
}

# Access into the cluster only allowed from the organizational IP range
# This is a security measure to ensure that only trusted IP addresses can access the EKS cluster.
variable "public_access_cidrs" {
  description = "The CIDR blocks that are allowed to access the EKS cluster's public endpoint. This should be set to the IP ranges of your organization for security purposes."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint. It is recommended to set this to false for security reasons, and use a VPN or Direct Connect for secure access."
  type        = bool
  default     = false
}

variable "endpoint_private_access" {
  description = "Whether to enable private access to the EKS cluster endpoint. This allows access to the cluster from within the VPC."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The instance type for the EKS node group."
  type        = string
  default     = "t3.medium"
}

variable "desired_size" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "eks_cluster_admin_principal_arns" {
  description = "IAM principal ARNs allowed to assume EKS-ClusterAdmin-Role. Defaults to account root when empty."
  type        = list(string)
  default     = []
}

variable "eks_read_only_principal_arns" {
  description = "IAM principal ARNs allowed to assume EKS-ReadOnly-Role. Defaults to account root when empty."
  type        = list(string)
  default     = []
}

variable "eks_namespace_admin_principal_arns" {
  description = "IAM principal ARNs allowed to assume EKS-NamespaceAdmin-Role. Defaults to account root when empty."
  type        = list(string)
  default     = []
}

variable "eks_namespace_admin_access_namespaces" {
  description = "Namespaces EKS-NamespaceAdmin-Role can administer through EKS access policy association."
  type        = list(string)
  default     = []
}

variable "eks_cicd_principal_arns" {
  description = "Additional IAM principal ARNs allowed to assume EKS-CICD-Deployer-Role."
  type        = list(string)
  default     = []
}

variable "eks_cicd_access_namespaces" {
  description = "Namespaces EKS-CICD-Deployer-Role can edit/deploy through EKS access policy association. No access policy association is created when empty."
  type        = list(string)
  default     = []
}

variable "github_oidc_provider_arn" {
  description = "Optional IAM OIDC provider ARN for GitHub Actions federation."
  type        = string
  default     = null
}

variable "github_actions_subject_claims" {
  description = "Allowed GitHub OIDC subject claims (sub) for EKS-CICD-Deployer-Role, such as repo:org/repo:ref:refs/heads/main."
  type        = list(string)
  default     = ["repo:*"]
}

variable "cicd_ecr_repository_arns" {
  description = "ECR repository ARNs that CI/CD can push/pull."
  type        = list(string)
  default     = ["*"]
}

variable "eks_cluster_admin_k8s_group" {
  description = "The name for the Kubernetes Group with Cluster Admin access"
  type        = string
  default     = "eks-cluster-admins"
}

variable "eks_read_only_k8s_group" {
  description = "The name for the Kubernetes Group with Read Only access"
  type        = string
  default     = "eks-read-only"
}

variable "eks_namespace_admin_k8s_group" {
  description = "The name for the Kubernetes Group with Namespace Admin access"
  type        = string
  default     = "eks-namespace-admins"
}

variable "eks_cicd_deployer_k8s_group" {
  description = "The name for the Kubernetes Group with CICD Deployer access"
  type        = string
  default     = "eks-cicd-deployers"
}
