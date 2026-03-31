data "aws_caller_identity" "current" {}

locals {
  tags = {
    Environment  = var.environment
    Project      = "${var.org_name} Cloud Management Platform"
    Owner        = "${var.org_name} Platform Team"
    ManagedBy    = "Terraform"
    ContactEmail = var.org_owner_email
  }

  cluster_role_prefix = replace(title(replace(var.cluster_name, "-", " ")), " ", "")
  cluster_role_name = "EKS${replace(title(replace(var.cluster_name, "-", " ")), " ", "")}Role"
  cluster_node_role_name = "EKS${replace(title(replace(var.cluster_name, "-", " ")), " ", "")}NodeRole"

  # If Terraform is running under an assumed role, aws_caller_identity returns an STS session ARN.
  # EKS access entries require the backing IAM role ARN, so normalize assumed-role sessions back to role ARNs.
  terraform_execution_principal_arn = can(regex("^arn:[^:]+:sts::[0-9]+:assumed-role/.+/[^/]+$", data.aws_caller_identity.current.arn)) ? replace(
    data.aws_caller_identity.current.arn,
    "/^arn:([^:]+):sts::([0-9]+):assumed-role\\/(.+)\\/[^\\/]+$/",
    "arn:$1:iam::$2:role/$3",
  ) : data.aws_caller_identity.current.arn
}

resource "aws_iam_role" "eks_cluster_role" {
  name = local.cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource aws_kms_key "eks_kms_key" {
  description = "KMS key for EKS cluster encryption"
  key_usage   = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7 # Key can be deleted after 7 days
  enable_key_rotation = true # Key will be rotated every year

  tags = {
    Name = "${var.cluster_name}-kms-key"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = "1.35" # EKS version set so that the cluster is created with a specific version of Kubernetes

  vpc_config {
    subnet_ids = var.subnet_ids # Cluster built on private subnets, created in VPC Terraform configuration
    endpoint_private_access = var.endpoint_private_access

    # Restricting public access to the cluster to the organization network IP range/known IP ranges
    # This is a security measure to ensure that only trusted IPs can access the cluster
    # Exemption has been made to deploy fluent-bit to the cluster
    # Would be advisable to use a VPN or Direct Connect for secure access to the cluster and deployment of workloads
    # with tools like kubectl/helm
    # Once fluent-bit(and any other k8s resources) is deployed, the public access can be disabled
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs = var.public_access_cidrs
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_kms_key.arn # KMS key for encryption
    }
    resources = ["secrets"] # Encrypting secrets in the cluster
  }

  zonal_shift_config {
    enabled = true # Increased resillience, moving traffic from failed availability zone
  }

  # Control plane logging enabled for security and auditing in Cloudwatch
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_kms_key.eks_kms_key
  ]
}

resource "aws_iam_role" "eks_node_role" {
  name = local.cluster_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = [var.instance_type]
  
  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"

  update_config {
    max_unavailable = 1 # 1 node at a time replaced during upgrades and health-check-triggered replacement
  }

  node_repair_config {
    enabled = true
  }

  tags = {
    Name = "${var.cluster_name}-ng"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policies
  ]
}

 
