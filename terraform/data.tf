data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = data.aws_eks_cluster.eks_cluster.name
}

data "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

data "aws_subnets" "private_subnets" {
  tags = {
    Name = var.private_subnets_name
  }
}