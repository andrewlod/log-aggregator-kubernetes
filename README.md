# Log Aggregator for Kubernetes
This project sets up the ELK stack in a Kubernetes cluster and stores snapshots on Amazon S3 with ElasticSearch.

## Table of Contents
- [Log Aggregator for Kubernetes](#log-aggregator-for-kubernetes)
  - [Table of Contents](#table-of-contents)
  - [Architecture](#architecture)
  - [Technologies](#technologies)
  - [Features](#features)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installing (development only)](#installing-development-only)
  - [Setup](#setup)
    - [Development](#development)
    - [Production](#production)
  - [Work-in-progress](#work-in-progress)
  - [Authors](#authors)
  - [License](#license)

## Architecture
![Log Aggregator Architecture](./assets/elk-diagram.png)

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

Then, enable the necessary addons:
```sh
microk8s enable ingress
microk8s enable dns
microk8s enable helm
microk8s enable dashboard
microk8s enable storage
```

Now you are ready to run the ELK stack in your local cluster!

## Setup
### Development
First of all, make sure your local Kubernetes cluster is up and running. If you are using Microk8s, you can start it by running the following command:
```sh
microk8s start
```

Add the Elastic Helm repository:
```sh
helm repo add elastic https://helm.elastic.co
```

Then, deploy ElasticSearch with the development configuration:
```sh
cd elasticsearch
make  AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID_WITH_S3_ACCESS> \
      AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY> \
      ELASTICSEARCH_PASSWORD=<INSERT_ANY_ELASTICSEARCH_PASSWORD> \
      install-dev
cd ..
```

The next step is to dpeloy Logstash:
```sh
cd logstash
make install
cd ..
```

Now, dpeloy Filebeat:
```sh
cd filebeat
make install
cd ..
```

Before deploying Kibana, make sure the Nginx ingress controller is installed:
```sh
cd nginx
make install
cd ..
```

And lastly, deploy Kibana with the development configuration:
```sh
cd kibana
make install-dev
cd ..
```

An additional step is to port-forward ElasticSearch and Kibana services to your host machine so you can access them:
```sh
kubectl port-forward svc/elasticsearch-master 9200 --address=0.0.0.0
kubectl port-forward svc/kibana-kibana 5601 --address=0.0.0.0
```

### Production
TODO: Describe production setup steps

## Work-in-progress
This section describes features that are either work-in-progress or will be implemented in the future. Features are sorted by priority.

- 🚧: Work-in-progress
- ❌: Not yet started

| Feature | Status |
|---------|--------|
| Create Terraform script with EKS serviceaccount and IAM Role for ElasticSearch | 🚧 |
| Integrate ElasticSearch with AWS EKS | ❌ |
| Create GitHub action for EKS deployment | ❌ |
| Include documentation about setting up Amazon S3 Snapshot and Restore | ❌ |
| Create architecture diagram and add it to documentation | ❌ |
| Record demo video of working logging solution on EKS and S3 | ❌ |

## Authors
- Andre Wlodkovski - [@andrewlod](https://github.com/andrewlod)

## License
This project is licensed under the [MIT License](https://opensource.org/license/mit) - see the [LICENSE](LICENSE) file for details.