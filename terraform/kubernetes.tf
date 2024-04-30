provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint                     ## aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

resource "kubernetes_service_account" "main" {
  metadata {
    name      = aws_iam_role.elasticsearch_s3_role.name
    namespace = var.k8s_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.elasticsearch_s3_role.arn
    }
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "elastic_config_credentials" {
  metadata {
    name      = "elastic-config-credentials"
    namespace = var.k8s_namespace
  } 

  data = {
    username = var.elasticsearch_username
    password = var.elasticsearch_password
  }
}