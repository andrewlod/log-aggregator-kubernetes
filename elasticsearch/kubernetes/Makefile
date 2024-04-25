default: test

RELEASE := helm-es-microk8s
TIMEOUT := 1200s

install:
	microk8s helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) elastic/elasticsearch

test: install
	microk8s helm test $(RELEASE)

purge:
	microk8s helm del $(RELEASE)