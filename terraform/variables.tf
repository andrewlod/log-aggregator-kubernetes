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
  default     = "monitoring"
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 bucket name to store ElasticSearch Snapshot and Restore data"
}

variable "elasticsearch_username" {
  type        = string
  description = "Username used to login on ElasticSearch and Kibana"
  default     = "elastic"
}

variable "elasticsearch_password" {
  type        = string
  description = "Password to log on ElasticSearch and Kibana"
  sensitive   = true
}

variable "private_subnets_name" {
  type        = string
  description = "Value of the 'Name' tag of private subnets"
}

variable "eks_instance_types" {
  type        = list(string)
  description = "List of instance types in the EKS Monitoring Node Group"
  default     = [ "t3.micro" ]
}