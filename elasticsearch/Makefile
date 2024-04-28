default: test

RELEASE := elasticsearch
TIMEOUT := 1200s

install-dev:
	microk8s kubectl delete secret aws-s3-credentials elastic-config-credentials || true
	microk8s kubectl create secret generic aws-s3-credentials --from-literal=s3.client.default.access_key=$(AWS_ACCESS_KEY_ID) --from-literal=s3.client.default.secret_key=$(AWS_SECRET_ACCESS_KEY)
	microk8s kubectl create secret generic elastic-config-credentials --from-literal=username=elastic --from-literal=password=$(ELASTICSEARCH_PASSWORD)
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values=values-dev.yaml $(RELEASE) elastic/elasticsearch

purge-dev:
	microk8s helm del $(RELEASE)
	microk8s kubectl delete secret aws-s3-credentials elastic-config-credentials || true

install-prod:
	microk8s kubectl delete secret elastic-config-credentials || true
	microk8s kubectl create secret generic elastic-config-credentials --from-literal=username=elastic --from-literal=password=$(ELASTICSEARCH_PASSWORD)
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values=values-prod.yaml $(RELEASE) elastic/elasticsearch

purge-prod:
	microk8s helm del $(RELEASE)
	microk8s kubectl delete secret elastic-config-credentials || true

test: install
	microk8s helm test $(RELEASE)