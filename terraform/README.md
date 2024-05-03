# Terraform deployment for the ELK Stack in AWS EKS
This is the documentation of the Terraform scripts that deploy the ELK stack in an existing AWS EKS cluster.

## Resources
The following AWS resources are deployed, but not limited to:
- Kubernetes
  - Namespace
  - Service Account
  - Secrets
- Helm Charts
  - ElasticSearch
  - Kibana
  - Logstash
  - Filebeat
- AWS EKS
  - Node Group
  - EBS Driver addon
- AWS IAM Roles
  - ElasticSearch access to S3 role
  - EKS Node Group role
  - EBS CSI role
- Amazon S3 bucket

## Getting Started
### Requirements
- [AWS CLI V2+](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Account](https://aws.amazon.com/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Optional] [Kubectl](https://kubernetes.io/docs/tasks/tools/)

### Variables
Create a variables file, such as `variables.tfvars`, and fill the following variables:
```tfvars
infra_env = "test"

aws_access_key_id     = ""
aws_secret_access_key = ""
aws_region            = "us-east-1"

k8s_namespace     = "monitoring"
eks_cluster_name  = ""
bucket_name       = ""

elasticsearch_username = "elastic"
elasticsearch_password = ""

private_subnets_name = ""

eks_instance_types = [ "t3.medium" ]
```

The variables that are already filled are mere examples and may be changed accordingly if needed.

## Deployment
### Running Terraform
First, it is necessary to install the Terraform dependencies by running the following command:
```sh
terraform init
```

Then, plan and apply:

```sh
terraform plan -out=tfplan -var-file=variables.tfvars
terraform apply tfplan
```

The commands shown above can also be run to make changes to the architecture, as it will check what resources need to be created/modified/destroyed.

### Destroying
In order to destroy the whole infrastructure, first make sure to:
- Delete all the contents of the S3 bucket created by Terraform

Then run the following command:
```sh
terraform destroy -var-file=variables.tfvars
```