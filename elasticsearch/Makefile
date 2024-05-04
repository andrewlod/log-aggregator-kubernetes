default: test

RELEASE := elasticsearch
TIMEOUT := 1200s
NAMESPACE := monitoring

install-dev:
	kubectl delete secret aws-s3-credentials elastic-config-credentials -n $(NAMESPACE) || true
	@kubectl create secret generic aws-s3-credentials --from-literal=s3.client.default.access_key=$(AWS_ACCESS_KEY_ID) --from-literal=s3.client.default.secret_key=$(AWS_SECRET_ACCESS_KEY) -n $(NAMESPACE)
	@kubectl create secret generic elastic-config-credentials --from-literal=username=elastic --from-literal=password=$(ELASTICSEARCH_PASSWORD) -n $(NAMESPACE)
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values=values-dev.yaml -n $(NAMESPACE) $(RELEASE) elastic/elasticsearch

purge-dev:
	helm del $(RELEASE)
	kubectl delete secret aws-s3-credentials elastic-config-credentials || true

install-prod:
	kubectl delete secret elastic-config-credentials -n $(NAMESPACE) || true
	kubectl create secret generic elastic-config-credentials --from-literal=username=elastic --from-literal=password=$(ELASTICSEARCH_PASSWORD) -n $(NAMESPACE)
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values=values-prod.yaml -n $(NAMESPACE) $(RELEASE) elastic/elasticsearch

purge-prod:
	helm del $(RELEASE) -n $(NAMESPACE)
	kubectl delete secret elastic-config-credentials -n $(NAMESPACE) || true

test: install
	helm test $(RELEASE) -n $(NAMESPACE)