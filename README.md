# Log Aggregator for Kubernetes
This project sets up the ELK stack in a Kubernetes cluster and stores snapshots on Amazon S3 with ElasticSearch.

## Table of Contents
- [Log Aggregator for Kubernetes](#log-aggregator-for-kubernetes)
  - [Table of Contents](#table-of-contents)
  - [Technologies](#technologies)
  - [Features](#features)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installing (development only)](#installing-development-only)
  - [Setup](#setup)
    - [Development](#development)
    - [Production](#production)
  - [Work-in-progress](#work-in-progress)
  - [Architecture](#architecture)
  - [Authors](#authors)
  - [License](#license)

## Technologies
- FileBeat - FileBeat collects logs from containers and sends them to Logstash
- Logstash - Collects logs from various sources and sends them to ElasticSearch to be indexed
- ElasticSearch - Indexes logs in a storage system and allows them to be queried
- Kibana - Allows the user to query ElasticSearch data and visualize the results
- Amazon S3 - Amazon Web Services Object Storage service

## Features
- Stdout and file log collection from containers with FileBeat
- Amazon S3 Snapshot and Restore
- Data querying
- Data visualization

## Getting Started
This step describes the prerequisites and steps for setting up the ELK stack in Kubernetes both locally and on AWS EKS.

### Prerequisites
- Microk8s, minikube or another local Kubernetes provider with Kubectl (for local development)
- Amazon Web Services account

### Installing (development only)
First install any Kubernetes local cluster manager. The following example shows how to install Microk8s:
```sh
sudo snap install microk8s --classic
```

Then, download and install Kubectl:
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

If you are using Microk8s, link the host kubectl command to the microk8s cluster:
```sh
cd $HOME
mkdir .kube
cd .kube
microk8s config > config
```

Now you are ready to run the ELK stack in your local cluster!

## Setup
### Development
TODO: Describe development setup steps

### Production
TODO: Describe production setup steps

## Work-in-progress
This section describes features that are either work-in-progress or will be implemented in the future. Features are sorted by priority.

- 🚧: Work-in-progress
- ❌: Not yet started

| Feature | Status |
|---------|--------|
| Create Terraform script with EKS serviceaccount and IAM Role for ElasticSearch | ❌ |
| Create GitHub action for EKS deployment | ❌ |
| Integrate ElasticSearch with AWS EKS | ❌ |
| Include documentation about setting up Amazon S3 Snapshot and Restore | ❌ |
| Create architecture diagram and add it to documentation | ❌ |
| Record demo video of working logging solution on EKS and S3 | ❌ |

## Architecture
TODO: Provide architecture diagram describing the solutions

## Authors
- Andre Wlodkovski - [@andrewlod](https://github.com/andrewlod)

## License
This project is licensed under the [MIT License](https://opensource.org/license/mit) - see the [LICENSE](LICENSE) file for details.