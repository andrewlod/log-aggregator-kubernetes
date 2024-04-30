provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.authentication_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.authentication_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.authentication_cluster.id]
      command     = "aws"
    }
  }
}

resource "helm_release" "elasticsearch" {
  name = "elasticsearch"

  repository = "https://helm.elastic.co"
  chart      = "elastic/elasticsearch"
  namespace  = var.k8s_namespace
  version    = "8.5.1"

  values = [
    "${file("${path.module}/../elasticsearch/values-prod.yml")}"
  ]

  set {
    name  = "rbac.serviceAccountName"
    value = aws_iam_role.elasticsearch_s3_role.name
  }

  depends_on = [
    kubernetes_secret.elastic_config_credentials,
    kubernetes_service_account.main
  ]
}

resource "helm_release" "kibana" {
  name = "kibana"

  repository = "https://helm.elastic.co"
  chart      = "elastic/kibana"
  namespace  = var.k8s_namespace
  version    = "8.5.1"

  values = [
    "${file("${path.module}/../kibana/values-prod.yml")}"
  ]

  depends_on = [
    helm_release.elasticsearch,
    kubernetes_secret.elastic_config_credentials
  ]
}

resource "helm_release" "logstash" {
  name = "logstash"

  repository = "https://helm.elastic.co"
  chart      = "elastic/logstash"
  namespace  = var.k8s_namespace
  version    = "8.5.1"

  values = [
    "${file("${path.module}/../logstash/values.yml")}"
  ]

  depends_on = [
    helm_release.elasticsearch,
    kubernetes_secret.elastic_config_credentials
  ]
}

resource "helm_release" "filebeat" {
  name = "filebeat"

  repository = "https://helm.elastic.co"
  chart      = "elastic/filebeat"
  namespace  = var.k8s_namespace
  version    = "8.5.1"

  values = [
    "${file("${path.module}/../filebeat/values.yml")}"
  ]

  depends_on = [
    helm_release.logstash,
    kubernetes_secret.elastic_config_credentials
  ]
}