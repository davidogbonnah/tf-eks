# Outputs could be limited to information required for authorization token, name and TLS Certificate

output "eks_cluster_name" {
    value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
    value = aws_eks_cluster.eks_cluster.endpoint
}

output "certificate_authority_data" {
    value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_identity" {
    value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}