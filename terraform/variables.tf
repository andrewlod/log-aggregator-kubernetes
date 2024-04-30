variable "infra_env" {
  type        = string
  description = "Infrastructure environment (prod/dev/test)"
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS primary region to create resources"
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  type        = string
  description = "AWS EKS cluster name to apply ElasticSearch resources"
}

variable "k8s_namespace" {
  type        = string
  description = "AWS EKS K8S namespace where ElasticSearch will be hosted"
  default     = "default"
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 bucket name to store ElasticSearch Snapshot and Restore data"
}