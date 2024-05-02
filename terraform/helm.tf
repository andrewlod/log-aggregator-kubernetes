provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.id]
      command     = "aws"
    }
  }
}

resource "helm_release" "elasticsearch" {
  name = "elasticsearch"

  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = var.k8s_namespace

  values = [
    "${file("${path.module}/../elasticsearch/values-prod.yaml")}"
  ]

  set {
    name  = "rbac.serviceAccountName"
    value = aws_iam_role.elasticsearch_s3_role.name
  }

  depends_on = [
    aws_eks_node_group.monitoring_node_group,
    aws_eks_addon.ebs_driver_addon,
    kubernetes_secret.elastic_config_credentials,
    kubernetes_service_account.main
  ]
}

resource "helm_release" "kibana" {
  name = "kibana"

  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = var.k8s_namespace

  values = [
    "${file("${path.module}/../kibana/values-prod.yaml")}"
  ]

  depends_on = [
    aws_eks_node_group.monitoring_node_group,
    helm_release.elasticsearch,
    kubernetes_secret.elastic_config_credentials
  ]
}

resource "helm_release" "logstash" {
  name = "logstash"

  repository = "https://helm.elastic.co"
  chart      = "logstash"
  namespace  = var.k8s_namespace

  values = [
    "${file("${path.module}/../logstash/values.yaml")}"
  ]

  depends_on = [
    aws_eks_node_group.monitoring_node_group,
    helm_release.elasticsearch,
    kubernetes_secret.elastic_config_credentials
  ]
}

resource "helm_release" "filebeat" {
  name = "filebeat"

  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = var.k8s_namespace

  values = [
    "${file("${path.module}/../filebeat/values.yaml")}"
  ]

  depends_on = [
    aws_eks_node_group.monitoring_node_group,
    helm_release.logstash,
    kubernetes_secret.elastic_config_credentials
  ]
}