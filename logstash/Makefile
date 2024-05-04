default: test

RELEASE := logstash
TIMEOUT := 1200s
NAMESPACE := monitoring

install:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml -n $(NAMESPACE) $(RELEASE) elastic/logstash

test: install goss

purge:
	helm del $(RELEASE) -n $(NAMESPACE)
	kubectl delete $$(kubectl get pvc -l release=$(RELEASE) -o name) -n $(NAMESPACE)