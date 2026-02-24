# Outputs could be limited to information required for authorization token, name and TLS Certificate

output "eks_cluster" {
    value = aws_eks_cluster.eks_cluster
}