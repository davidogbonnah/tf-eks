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
  default     = "t3.small"
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
  default     = 1
}