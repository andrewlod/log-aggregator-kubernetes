locals {
  elasticsearch_role_name = "elasticsearch-s3-role"
}

resource "aws_iam_role" "elasticsearch_s3_role" {
  name               = local.elasticsearch_role_name
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.oidc.arn
      }
      Condition = {
        StringEquals = {
          "${data.aws_iam_openid_connect_provider.oidc.url}:sub" = "system:serviceaccount:${var.k8s_namespace}:${local.elasticsearch_role_name}"
          "${data.aws_iam_openid_connect_provider.oidc.url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    "Environment"   = var.infra_env
    "Name"          = local.elasticsearch_role_name
    "Project"       = "log-aggregator"
    "ManagedBy"     = "terraform"
    "Organization"  = "andrewlod"
  }
}

resource "aws_iam_role_policy" "elasticsearch_s3_policy" {
  name = "elasticsearch-s3-policy"
  role = aws_iam_role.elasticsearch_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:ListBucketVersions"
        ]
        Resource = aws_s3_bucket.elasticsearch_s3_bucket.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = "${aws_s3_bucket.elasticsearch_s3_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name               = "eks-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    "Environment"   = var.infra_env
    "Name"          = "eks-node-role"
    "Project"       = "log-aggregator"
    "ManagedBy"     = "terraform"
    "Organization"  = "andrewlod"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_vpc_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr_read_only_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role" "ebs_csi_role" {
  name               = "eks-ebs-csi-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.oidc.arn
      }
      Condition = {
        StringEquals = {
          "${data.aws_iam_openid_connect_provider.oidc.url}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          "${data.aws_iam_openid_connect_provider.oidc.url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    "Environment"   = var.infra_env
    "Name"          = "eks-ebs-csi-role"
    "Project"       = "log-aggregator"
    "ManagedBy"     = "terraform"
    "Organization"  = "andrewlod"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role.name
}