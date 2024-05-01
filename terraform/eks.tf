resource "aws_eks_node_group" "monitoring_node_group" {
  cluster_name    = data.aws_eks_cluster.eks_cluster.name
  node_group_name = "monitoring-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = toset(data.aws_subnets.private_subnets.ids)
  instance_types  = var.eks_instance_types

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_ecr_read_only_policy_attachment,
    aws_iam_role_policy_attachment.eks_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_node_vpc_policy_attachment,
    aws_iam_role_policy_attachment.eks_node_worker_node_policy_attachment
  ]
}