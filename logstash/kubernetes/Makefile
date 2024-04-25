default: test

RELEASE := helm-logstash-elasticsearch
TIMEOUT := 1200s

install:
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) elastic/logstash

test: install goss

purge:
	microk8s helm del $(RELEASE)
	microk8s kubectl delete $$(microk8s kubectl get pvc -l release=$(RELEASE) -o name)