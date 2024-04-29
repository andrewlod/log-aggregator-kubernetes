resource "aws_s3_bucket" "elasticsearch_s3_bucket" {
  bucket = var.bucket_name

  tags = {
    "Environment"   = var.infra_env
    "Name"          = var.bucket_name
    "Project"       = "log-aggregator"
    "ManagedBy"     = "terraform"
    "Organization"  = "andrewlod"
  }
}